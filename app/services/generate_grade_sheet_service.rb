require "zlib"

class GenerateGradeSheetService
    def self.create_gs_latex(options={})
        @exam = options[:exam]
        @record_type = options[:record_type]
        @folder = options[:folder]
        @gradesheet_type = options[:student_type]
        @courses = Course.where(exam_uuid:@exam.uuid).order(:sl_no)
        @members = @exam.workforces.where(role:"member").order(:sl_no)
        @tabulators = @exam.workforces.where(role:"tabulator").order(:sl_no)
        @tco = Course.where(exam_uuid:@exam.uuid).sum(:credit).round
        data = generate_gs_view(options) 
        perform(data)
        true
    end

    def self.perform(options={})
      MyLogger.info "Writing files: " + Rails.root.join(@folder, [@exam.uuid, @gradesheet_type.to_s, '_gs.tex'].join("_")).to_s
      f_data = latex_gs_template(options)
      File.open(Rails.root.join(@folder, [@exam.uuid, @gradesheet_type.to_s, '_gs.tex'].join("_")), 'w') do |f| 
       f.puts f_data
      end
      @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid: @gradesheet_type.to_s + ' gradesheets') || Doc.new(exam_uuid:@exam.uuid, uuid: @gradesheet_type.to_s + ' gradesheets') 
      @doc.latex_loc = @folder + '/'+ [@exam.uuid, @gradesheet_type.to_s, '_gs.tex'].join("_")
      @doc.latex_name = ["grade", "sheets", " ", @gradesheet_type.to_s ,".tex"].join("_")
      @doc.latex_str = Base64.encode64(Zlib::Deflate.deflate(f_data))
      @doc.description = ["grade", "sheets", @gradesheet_type.to_s].join("_").titlecase
	  @doc.save
    end

    def self.latex_gs_template(options) 
          header = gs_header
            main = ''
            options.each do |data| 
                main << main_preamble(data) << course_body(data[:courses]) << main_footer(data)
            end
           footer = gs_footer

         header + main + footer
    end

    def self.generate_gs_view(options)
      a = []
      @tab = Tabulation.where(exam_uuid:options[:exam].uuid, student_type: options[:student_type].to_s, :record_type=>options[:record_type]).order(:sl_no)
      @tab.each do |t| 
        s = Student.find_by(roll: t.student_roll)
        r = Registration.find_by(student:s, exam_uuid:options[:exam].uuid)
        @retHash = Hash.new
        @retHash[:gpa] = t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = t.tce.round
        @retHash[:roll] = s.roll
        @retHash[:name] = s.name
        @retHash[:email] = s.email
        @retHash[:hall] = s.hall_name;
        @retHash[:sl_no] = r.sl_no 
        @retHash[:courses] = []
        @retHash[:remarks] = t.remarks
        @retHash[:tps] = t.tps
        t.tabulation_details.each do |td|
            course = {:code=> td.summation.course.display_code, :title=>td.summation.course.title, :credit=>td.summation.course.credit, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2) }
            @retHash[:courses] << course
        end 
        a << @retHash
      end
      a
    end

    def self.gs_header
          <<-EOF      
           \\documentclass[11pt]{article}
           \\usepackage[paperwidth=30cm, paperheight=21cm,left=0.78in,top=0.25in,right=0.3in,bottom=0.2in]{geometry}
            \\setlength\\parskip{0pt}
            \\usepackage{array}
            \\usepackage{graphicx}
            \\usepackage{utopia}
            \\usepackage[T1]{fontenc}
            \\usepackage{ifthen}
            \\pagestyle{empty}
            \\usepackage{xstring} 

            \\newcommand*{\\numtwo}[1]{\\pgfmathprintnumber[
                    fixed, precision=2, fixed zerofill=true]{#1}}
            \\begin{document}
            EOF
    end

    def self.gs_footer
        <<-EOF 
            \\end{document}
         EOF

    end

    def self.main_preamble(data)
         <<-EOF 
             \\begin{table}[ht]
            \\begin{minipage}[m]{0.3\\linewidth}  

            \\vspace*{-3.0cm} 
            \\begin{tabular}{l >{\\hspace*{-1.8ex}}p{2.6in}} % >{\\raggedleft}m{1.5in}}
                Name &: \\textsc{#{data[:name]}}\\\\  
                ID No. &: $#{data[:roll]}$\\\\ 
                Hall &: #{data[:hall]} \\\\ 
                \\end{tabular} 
                \\end{minipage}
               %% \\hspace{0.3cm}
                \\begin{minipage}[b]{0.38\\textwidth}
                    \\vspace*{.5in}
                \\centering \\includegraphics[width=0.6in]{cu-logo.jpg}

                \\smallskip

                \\noindent {\\textsc{University of Chittagong}}\\\\
               %% \\textsc{ Institute : #{data[:hall]}} \\\\ 
                \\textsc{Department of Computer Science and Engineering}\\\\

                \\smallskip

                {\\large {\\sc Grade Sheet #{ '(Improvement)' if  @gradesheet_type ==  :improvement }}}\\\\

                \\smallskip
                \\textsc{#{@exam.fullname}}\\\\
                {Held in #{@exam.held_in}}\\\\
                \\end{minipage}
              %%  \\hspace{0.2cm}
                \\begin{minipage}[m]{0.3\\linewidth} \\flushright
                \\vspace*{-1.5in}  
                {\\flushright \\bf	Serial No~:~#{data[:sl_no]} \\\\}
                \\vspace{4mm}
                \\begin{small}
                \\renewcommand{\\arraystretch}{1.01}
                \\begin{tabular}{ |c|>{\\centering}m{0.9cm}|m{0.91cm}|} 
                    \\hline {\\bf Numerical Range} & {\\bf Letter Grade} & {\\bf Grade Point} \\\\
                \\hline   80\\% and above & A+ & $4.00$  \\\\ 
                \\hline   75\\% to less than 80\\% &  A & $3.75$\\\\ 
                \\hline   70\\% to less than 75\\% &  A- & $3.50$ \\\\ 
                \\hline   65\\% to less than 70\\% &  B+ & $3.25$\\\\ 
                \\hline   60\\% to less than 65\\% &  B  & $3.00$\\\\ 
                \\hline   55\\% to less than 60\\% &  B- & $2.75$\\\\ 
                \\hline   50\\% to less than 55\\% &  C+ & $2.50$\\\\ 
                \\hline   45\\% to less than 50\\% &  C  & $2.25$\\\\
                \\hline   40\\% to less than 45\\% &  D  & $2.00$\\\\
                \\hline   Less than 40\\%         &  F  & $0.00$\\\\ 
                \\hline   Incomplete/Absent         &  X  & X\\\\ 
                \\hline 
                
                \\end{tabular}
                \\end{small} 
                \\end{minipage}
                \\end{table}
                \\vspace*{-0.5cm}
                \\begin{center}
                    %\\hspace*{1in}
                    \\renewcommand{\\arraystretch}{1.08}
                    
                \\begin{tabular}{|c|l|c|>{\\scshape}c|c|c|}
                \\hline  \\rule[-1ex]{0pt}{3.5ex} {\\centering{\\bf Course Code}} &  \\multicolumn{1}{c|}{\\textbf{Course Title}}  & {\\bf Credits} & {\\bf Letter Grade} & {\\bf Grade Point} & {\\bf Credit Points}  \\\\ 
                EOF
    end

    def self.main_footer(data)
         <<-EOF 
                %\\hline 
                \\end{tabular}
                \\end{center}
                \\renewcommand{\\arraystretch}{1.03}

                \\begin{center}
               
                 \\begin{tabular}{lrr}
                 Total Credits Offered: $#{@tco}$ &  Total Credits Earned: $#{data[:tce]}$ &   Total Credit Points: $#{data[:tps]}$   \\\\
                 Grade Point Average (GPA): \\fbox{\\bf~#{'%.2f' % data[:gpa]}} & Result: \\fbox{\\bf~{#{data[:result]}}~} & #{'Remarks:  \\fbox{\\bf~{' + data[:remarks] +' }~}' unless data[:remarks].blank?} \\\\
                 \\end{tabular}

                %% \\begin{tabular}{p{1.8in} >{\\raggedright}p{1.8in} p{0.1in} >{\\raggedright}p{2.8in} >{\\raggedleft}p{1.0in}>{\\raggedleft}p{1.7in}}
               %% Total Credits Offered: $#{@tco}$ &  Total Credits Earned: $#{data[:tce]}$ & &  Grade Point Average (GPA): \\fbox{\\bf~#{'%.2f' % data[:gpa]}} & Result: \\fbox{\\bf~{#{data[:result]}}~} & #{'Remark:  \\fbox{\\bf~{' + data[:remarks] +'}~}' unless data[:remarks].blank?} \\\\
               %% \\end{tabular}


                \\end{center}
            \\vspace{1cm}
            \\centering\\begin{table}[hb]
            \\begin{minipage}[b]{0.33\\linewidth}  
            \\noindent Date of Publication :  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$\\bigskip

            \\vspace*{1ex}
            \\smallskip
            \\noindent Date of Issue \\hspace*{6ex}:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$
            \\end{minipage}
            \\hspace{2.3cm}
            \\begin{minipage}[b]{0.33\\linewidth}
            \\noindent Prepared By \\hspace*{1.3ex}: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$\\bigskip

            \\vspace*{1.5ex}
            \\smallskip
            \\noindent Compared By : \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$
            \\end{minipage}
            \\hspace*{1.2cm}
            \\begin{minipage}[b]{0.19\\linewidth} \\centering
            Controller of Examinations  \\hspace*{1ex}

            University of Chittagong
            \\end{minipage}
            \\end{table}

            \\clearpage
              EOF
    end

    def self.course_body(courses)
          a = ''
          courses.each do |course|
            a << 
            <<-EOF
                \\hline   #{course[:code]} &  #{course[:title]}		 & #{course[:credit]} & #{course[:lg]} & #{'%.2f' % course[:gp]} & #{ '%.2f' % course[:ps]} \\\\ %\\numtwo{summation.gp} %\\\\ 
            EOF
          end
          a << "\n\\hline"
        a   
    end

end


# {info[:permittedDepotName]}