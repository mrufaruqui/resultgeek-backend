class GenerateTabulationLatexService < TabulationBaseService
   
    def self.create_tabulation_latex(options={})
        @exam = options[:exam]
        @courses = Course.where(exam_uuid:@exam.uuid)
        @members = @exam.workforces.where(role:"member")
        @tabulators = @exam.workforces.where(role:"tabulator")
        @number_of_tabulation_column  = Course.where(:course_type=>"theory").count * 4 + Course.where(:course_type=>"lab").count * 2 + 7
        @hall_list = (Student.all - Student.where(hall_name:nil)).pluck(:hall_name).uniq
        @hall_name = ' '
        perform(options)
      true
    end

    def self.perform(options={})
      File.open( ['reports/',@exam.uuid, 'tabulation.tex'].join, 'w') do |f| 
       f.puts latex_tabulation_template(options)
      end

      @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid:'tabulation') || Doc.new(exam_uuid:@exam.uuid, uuid:'tabulation_v2') 
	  @doc.latex_loc = ['reports/', @exam.uuid, 'tabulation.tex'].join
      @doc.latex_name = [@exam.uuid.titlecase, '_tabulation.tex'].join
      @doc.description = ["tabulation", "sheets"].join("_").titlecase
	  @doc.save
    end

    def self.latex_tabulation_template(options) 
          tab_xls = Hash.new
          tab_xls[:tabulations] = []
          @courses = Course.all;
          header = tabulation_header
          main = ''
          @hall_list.each do |hall|
            @hall_name = hall
            total_students_in_a_hall = Tabulation.joins(:student).merge(Student.where(hall_name:hall)).count
            batch_size = (total_students_in_a_hall % 8  == 0) ?  total_students_in_a_hall / 8.to_i : (total_students_in_a_hall / 8.to_i)+1.to_i
            batch_size.times.each do |item|
                    main << main_preamble() 
                    #Tabulation.find_each(batch_size:10) do |t|
                    Tabulation.joins(:student).merge(Student.where(hall_name:hall)).limit(8).offset(item * 10).each do |t|
                    data = generate_single_page_tabulation(t)
                    tab_xls[:tabulations] = data
                    main << course_body(data) 
                    end
                    main << main_footer()
                end
                main << "\\clearpage\n"
            end

         footer = tabulation_footer
         header + main + footer
    end

   
    
    def self.tabulation_header
          <<-EOF      
           \\documentclass[11pt]{article}
            \\usepackage[a3paper, landscape, left=0.78in,top=0.25in,right=0.3in,bottom=0.2in]{geometry}
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

    def self.tabulation_footer
        <<-EOF 
            \\end{document}
         EOF

    end


    def self.main_preamble(data={})
       part_a =  <<-EOF 
\\begin{table}[ht]
\\begin{tabularx}{\\linewidth}{llll}
    EOF
part_b = grading_system + "&\n" + abbreviations + "&\n" + exam_info + "&\n" + course_info + "\n"
part_c = <<-EOF   
\\end{tabularx}
\\end{table}


\\vspace*{-0.5cm}
\\begin{center}
	%\\hspace*{1in}
	\\renewcommand{\\arraystretch}{1.08}
	
	\\begin{small}
\\begin{tabularx}{\\linewidth}{|X|X|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|c|X|X|} \\hline
    \\bf ID No. & \\bf Student Name &\\multicolumn{4}{c|}{\\textbf{CSE 111}}  & \\multicolumn{4}{c|}{\\textbf{CSE 113}} & \\multicolumn{2}{c|}{\\textbf{CSE 114}} & \\multicolumn{4}{c|}{\\textbf{EEE 121}} & \\multicolumn{2}{c|}{\\textbf{EEE 122}} &  \\multicolumn{4}{c|}{\\textbf{MAT 131}} & \\multicolumn{4}{c|}{\\textbf{STA 151}} & TCE & TPS & GPA & Result & Remarks  \\\\ \\hline
	 
    &   & CATM & FEM & MO & LG     & CATM & FEM & MO &  LG   & MO & LG   & CATM & FEM & MO & LG   & MO & LG   & CATM & FEM & MO & LG   & CATM & FEM & MO & LG   &  &   &   &  \\\\ \\hline
            EOF
        part_a + part_b + part_c
    end

    def self.main_footer(data ={})
         <<-EOF 
            \\end{tabularx}
            \\end{small}
            \\end{center}
            %\\end{minipage}
            %\\hspace*{3ex}
            %\\begin{minipage}[t]{0.35\\linewidth}
            \\renewcommand{\\arraystretch}{1.03}
            \\vspace{-0.6 cm}




            \\vspace*{1cm}


            
            % 
            %\\vspace*{-0.4cm}
            \\centering\\begin{table}[hb]
            \\begin{minipage}[b]{0.33\\linewidth} %\\centering
            {\\centering Tabulators }
            \\begin{enumerate}
             \\item #{@tabulators[0].teacher.display_name unless @tabulators[0].nil?} \\hspace*{1ex} $\\ldots \\ldots  $  
             \\item #{@tabulators[1].teacher.display_name unless @tabulators[1].nil? || @tabulators.length < 2} \\hspace*{1ex} $\\ldots \\ldots  $  
             \\item #{@tabulators[2].teacher.display_name unless @tabulators[2].nil? || @tabulators.length < 3} \\hspace*{1ex} $\\ldots \\ldots $  
            \\end{enumerate} 

            \\end{minipage}
            \\hspace{2.3cm}
            \\begin{minipage}[b]{0.33\\linewidth}
            {\\centering Exam Committee}
            \\begin{enumerate}
            \\item #{@exam.workforces.find_by(role:"chairman").teacher.display_name}  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ --  Chairman
            \\item #{@members[0].teacher.display_name unless @members[0].nil?}  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ -- Member
            \\item #{@members[1].teacher.display_name unless @members[1].nil? || @members.length < 2}  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$-- Member
            \\end{enumerate} 
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

    def self.course_body(data)
          a = ''
          a << [data[:roll], data[:name]].join(' & ') << ' & '
          
          @courses.each do |course|
            if course.course_type === "lab"
                a << [data[course.code][:mo], data[course.code][:lg]].join(' & ') << ' & ' if data.include? course.code
             else
                a << [data[course.code][:cact], data[course.code][:fem], data[course.code][:mo], data[course.code][:lg]].join(' & ') << '&' if data.include? course.code
             end
          end

         a << [data[:tce], data[:tps], data[:gpa], data[:result]].join(' & ')   #"\\multirow{3}{*}{#{data[:remarks]}}"
         a << "\\\\"
          
          30.times.each {a << ' & '}
          a << "\\\\\n"
          
          30.times.each {a << ' & '}
          a << "\\\\\n"

          a << "\\hline"
        a   
    end


    def self.grading_system
        <<-EOF
     \\begin{minipage}[m]{0.3\\linewidth} \\flushleft
%\\vspace*{3.0cm} 
\\begin{small}
\\begin{tabular}{ |c|>{\\centering}m{0.9cm}|m{0.91cm}|}%| c | >{\\centering}p{1cm} | >{\\centering}p{1cm} |}
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
     EOF
    end

    def self.abbreviations 
        <<-EOF
\\begin{minipage}[m]{0.3\\linewidth} %\\centering
	\\hspace{-5cm}
%	\\vspace*{-3.0cm} 
	\\begin{small}
		\\renewcommand{\\arraystretch}{1.01}{
			\\begin{tabular}{ |c|} 
				\\hline {\\bf	ABBREVIATIONS } \\\\		
				\\hline 	NG = Numerical Grade		 \\\\			
				\\hline 	LG = Letter Grade			 \\\\		
				\\hline 	GP = Grade Points			 \\\\		
				\\hline	CATM = Class Attendance \\\\ 
				and Class Test Marks	 \\\\				
				\\hline 	FEM = Final Exam Marks				
				\\\\	
				\\hline 	MO = Marks Obtained				
				\\\\	
				\\hline 	CP = Credit Points = Credit x GP	 \\\\				
				\\hline 	TCE = Total Credit Earned		 \\\\			
				\\hline 	TCP = Total Credit Points		 \\\\			
				\\hline 	GPA = Grade Point Average = TCP/18		 \\\\	 
				\\hline 
				
			\\end{tabular}
		}
	\\end{small}
\\end{minipage}

     EOF

    end

    def self.exam_info
        <<-EOF
     \\hspace{-5in}
\\begin{minipage}[m]{0.35\\textwidth} \\centering
%	\\vspace*{-0.2in} 
\\includegraphics[width=0.6in]{cu-logo.jpg}
	
	\\smallskip
	
	\\noindent {\\textsc{University of Chittagong}}\\\\
	\\textsc{Department of Computer Science \\& Engineering}\\\\
	
	\\smallskip
	
	{\\large {\\sc Tabulation Sheet}}\\\\
	{\\large {\\sc Hall: #{@hall_name}}}\\\\
	
	\\smallskip
	\\textsc{#{@exam.fullname}}\\\\
	{Held in #{@exam.held_in}}\\\\
\\end{minipage}
EOF
    end

    def self.course_info
      _course_info_a = <<-EOF
\\hspace{1cm}
\\begin{minipage}[m]{0.3\\linewidth} \\flushright
%	\\vspace*{-1in} %\\centering 
	%{\\flushright \\bf	Serial No:\\sl \\\\}
	%\\vspace{4mm}
	\\hspace{-5cm}
	\\begin{small}
		\\renewcommand{\\arraystretch}{1.01}
		\\begin{tabular} {|l|l|r|r|}
			\\hline \\hline Code & Title  & Credit &  Marks \\\\ \\hline
EOF
	 
    a = ''
    @courses.each  do |course|
        a << "\\hline  " << [course.display_code, course.title, course.credit, course.credit * 25].join(' & ') << "  \\\\\n"
    end
 _course_info_b = a
 
 _course_info_c= <<-EOF
 \\hline
		\\end{tabular}
	\\end{small} 
\\end{minipage}
EOF
 _course_info_a + _course_info_b + _course_info_c
    end
def self.generate_single_page_tabulation(t) 
        @retHash = Hash.new
        @retHash[:sl_no] = t.sl_no
        @retHash[:gpa] = '%.2f' % t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = '%.2f' % t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = t.student.roll
        @retHash[:name] = t.student.name
        @retHash[:hall] = t.student.hall_name;
        @retHash[:courses] = []
        tps = 0.0;
        t.tabulation_details.each do |td|
            course = Hash.new
            ps = ( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2)
            if td.summation.course.course_type === "lab"
               @retHash[td.summation.course.code] =  {:mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            else
               @retHash[td.summation.course.code] = {:cact=>td.summation.cact, :fem=>td.summation.marks, :mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            end  
            tps += ps;
          #  @retHash[:courses] << course
        end
        @retHash[:tps] = '%.2f' % tps; 
        @retHash
      end    
end