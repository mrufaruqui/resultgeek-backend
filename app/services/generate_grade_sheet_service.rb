class GenerateGradeSheetService
    
    def self.create_gs_latex(options={})
         options = generate_gs_view
         perform(options)
    end

    def self.perform(options={})
    File.open(File.join('./reports/', 'gs.tex'), 'w') do |f| 
       f.puts latex_gs_template(options)
      end
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

    def self.generate_gs_view(options={})
      a = []
      @tab = Tabulation.all
      @tab.each do |t| 
        @retHash = Hash.new
        @retHash[:gpa] = t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = t.tce
        @retHash[:roll] = t.student.roll
        @retHash[:name] = t.student.name
        @retHash[:hall] = t.student.hall_name;
        @retHash[:courses] = []
        t.tabulation_details.each do |td|
            course = {:code=> td.summation.course.id, :title=>td.summation.course.title, :credit=>td.summation.course.credit, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2) }
            @retHash[:courses] << course
        end
        puts @retHash
        a << @retHash
      end
      a
    end

    def self.gs_header
          <<-EOF      
           \\documentclass[11pt]{article}
           \\usepackage[paperwidth=30cm, paperheight=21cm,left=0.78in,top=0.25in,right=0.3in,bottom=0.2in]{geometry}
            \\setlength\\parskip{0pt}
            \\usepackage{datatool}
            \\usepackage{calc}
            \\usepackage{array,tabularx}
            \\usepackage{graphicx,pgf}
            \\usepackage{utopia}
            \\usepackage[T1]{fontenc}
            \\usepackage{ifthen}
            \\pagestyle{empty}
            \\usepackage{xstring}
            \\usepackage{multirow}

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
                Session &: \\IfSubStr{#{data[:roll]}}{1770}{$2017-2018$}{$2018-2019$}\\\\ 
                Roll/ID No. &: $#{data[:roll]}$\\\\ 
                Hall &: #{data[:hall]} \\\\ 
                \\end{tabular} 
                \\end{minipage}
                \\hspace{0.3cm}
                \\begin{minipage}[b]{0.35\\textwidth}
                    \\vspace*{.5in}
                \\centering \\includegraphics[width=0.6in]{cu-logo.jpg}

                \\smallskip

                \\noindent {\\textsc{University of Chittagong}}\\\\
                \\textsc{Department of Computer Science \\& Engineering}\\\\

                \\smallskip

                {\\large {\\sc Grade Sheet}}\\\\

                \\smallskip
                \\textsc{$1^{st}$ Semester B.Sc. Engineering Examination 2018}\\\\
                {Held in May  - June 2018}\\\\
                \\end{minipage}
                \\hspace{0.2cm}
                \\begin{minipage}[m]{0.3\\linewidth} \\flushright
                \\vspace*{-1.5in}  
                {\\flushright \\bf	Serial No:\\sl \\\\}
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
                \\hline  \\rule[-1ex]{0pt}{3.5ex} {\\centering{\\bf Course Code}} &  \\multicolumn{1}{c|}{\\textbf{Course Title}}  & {\\bf Credits} & {\\bf Letter Grade} & {\\bf Grade Point} & {\\bf Point Secured}  \\\\ 
                EOF
    end

    def self.main_footer(data)
         <<-EOF 
                %\\hline 
                \\end{tabular}
                \\end{center}
                \\renewcommand{\\arraystretch}{1.03}

                \\begin{center}
                \\begin{tabular}{p{1.5in} >{\\raggedright}p{1.6in} p{0.1in} >{\\raggedright}p{2.8in} >{\\raggedleft}p{1.0in}}
                Credits Offered: $18$ &  Credits Earned: $#{data[:tce]}$ & &  Grade Point Average (GPA): \\fbox{\\bf~#{data[:gpa]}} & Result: \\fbox{\\bf~{#{data[:result]}}~} \\\\
                \\end{tabular}
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
                \\hline   #{course[:code]} &  #{course[:title]}		 & #{course[:credit]} & #{course[:lg]} & #{course[:gp]} & #{course[:ps]} \\\\ %\\numtwo{summation.gp} %\\\\ 
            EOF
          end
          a << "\n\\hline"
        a   
    end

end


# {info[:permittedDepotName]}