class GenerateTabulationLatexV4Service < TabulationBaseService

	def perform(options={})
	    @student_type = options[:student_type]
	    @exam = options[:exam]
		@courses = Course.where(exam_uuid:@exam.uuid).order(:sl_no)
        @members = @exam.workforces.where(role:"member").order(:sl_no)
        @tabulators = @exam.workforces.where(role:"tabulator").order(:sl_no)
        @number_of_tabulation_column  = @courses.where(:course_type=>"theory").count * 4 + @courses.where(:course_type=>"lab").count * 2 + 7
		@hall_list =  Tabulation.where(exam_uuid:@exam.uuid).pluck(:hall_name).uniq
		@tco = @courses.where(exam_uuid:@exam.uuid).sum(:credit).round
		@hall_name = ''
	  
	  f_data = latex_tabulation_template(options)
	  MyLogger.info "Writing files: " + Rails.root.join('reports/',[@exam.uuid, @student_type.to_s, 'tabulation_v4.tex'].join("_")).to_s
      File.open( Rails.root.join('reports/', [@exam.uuid, @student_type.to_s, 'tabulation_v4.tex'].join("_")), 'w') do |f| 
       f.puts f_data
	  end
	 
	#   @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v4') || Doc.new(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v4') 
	#   @doc.latex_loc = 'reports/' + [@exam.uuid, @student_type.to_s, 'tabulation_v4.tex'].join("_")
	#   @doc.latex_name =  ["tabulation", "sheets", "v4", @student_type.to_s ,".tex"].join("_")
	#   @doc.latex_str =   MyCompressionService.compress f_data
	#   @doc.description = ["tabulation", "sheets", @student_type.to_s ].join("_").titlecase
	#   @doc.save
	 
	  true
    end

      def  latex_tabulation_template(options) 
          tab_xls = Hash.new
          tab_xls[:tabulations] = []
          header = tabulation_header
          main = ''
          options = Hash.new
          @hall_list.each do |hall|
            @hall_name = hall
            total_students_in_a_hall = Tabulation.where(exam_uuid:@exam.uuid, hall_name:hall).count
            batch_size = (total_students_in_a_hall % 6 == 0) ?  total_students_in_a_hall / 6.to_i : (total_students_in_a_hall / 6.to_i)+1.to_i
            batch_size.times.each do |item|
                    main << main_preamble() 
                    #Tabulation.find_each(batch_size:10) do |t|
                    Tabulation.where(exam_uuid:@exam.uuid, hall_name:hall).limit(6).offset(item + 6).each do |t|
                        options[:t] = t
                        data = generate_single_page_tabulation(options)
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

   
    
    def  tabulation_header
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
           	\\usepackage{rotating}
            \\newcommand*\\rot{\\rotatebox{90}}
            \\newcommand*{\\numtwo}[1]{\\pgfmathprintnumber[
                    fixed, precision=2, fixed zerofill=true]{#1}}
            \\begin{document}
            EOF
    end

    def  tabulation_footer
        <<-EOF 
            \\end{document}
         EOF

    end


    def  main_preamble(data={})
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
        
        EOF

        # part_d = <<-EOF  
        #  {|X|X|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|c|X|X|} \\hline
        
        # \\bf ID No. & \\bf Student Name &\\multicolumn{4}{c|}{\\textbf{CSE 111}}  & \\multicolumn{4}{c|}{\\textbf{CSE 113}} & \\multicolumn{2}{c|}{\\textbf{CSE 114}} & \\multicolumn{4}{c|}{\\textbf{EEE 121}} & \\multicolumn{2}{c|}{\\textbf{EEE 122}} &  \\multicolumn{4}{c|}{\\textbf{MAT 131}} & \\multicolumn{4}{c|}{\\textbf{STA 151}} & TCE & TPS & GPA & Result & Remarks  \\\\ \\hline
            
        #   &   &  CA & FEM & MO & LG     &  CA & FEM & MO &  LG   & MO & LG   &  CA & FEM & MO & LG   & MO & LG   &  CA & FEM & MO & LG   &  CA & FEM & MO & LG   &  &   &   &  \\\\ \\hline
        # EOF

        c=[]
		c << "\\begin{tabularx}{\\linewidth}{|X|X|"
		@courses.each do | course|
			if course.course_type == "theory"	
                4.times.each{ c << "l"}
                c<<"|"
			else
                2.times.each{ c << "l"}
                c<<"|"
            end
           
		end 
        c << "l|l|c|c|X|}\\\\ \\hline"
        part_d = c.join


        d=[]
		d << "\\bf ID No." << "\\bf Student Name"
		@courses.each do | course|
			if course.course_type == "theory"	
				d << "\\multicolumn{4}{c|}{\\textbf{#{course.display_code}}}"
			else
				d << "\\multicolumn{2}{c|}{\\textbf{#{course.display_code}}}"
            end
          
		end 
         d << "\\rot{ TCE}" <<  "\\rot{ TPS}"  << "\\rot{ GPA}" << "\\rot{ Result }" << "Remarks"  
        
        part_f = d.join("&") + "\\\\ \\hline"


        d=[]
		d << " " << " "
		@courses.each do | course|
			if course.course_type == "theory"	
				d << " CA" << "FEM" << "MO" << "LG"
			else
				d << "MO" << "LG"
            end
          
		end 
         d << " " <<  " "  << " " << " " << " "  
        
        part_g = d.join("&") + "\\\\ \\hline"


        part_a + part_b + part_c + part_d + part_f + part_g
    end

    def  main_footer(data ={})
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

    def  course_body(data)
        
          a = ''
          (@number_of_tabulation_column -1).times.each {a << ' & '}
           a << "\\\\\n"
          a << [data[:roll], data[:name]].join(' & ') << ' & '
          
          @courses.each do |course|
            if course.course_type === "lab"
                a << [data[course.code][:mo], data[course.code][:lg]].join(' & ') << ' & ' if data.include? course.code
             else
                a << [data[course.code][:cact], data[course.code][:fem], data[course.code][:mo], data[course.code][:lg]].join(' & ') << '&' if data.include? course.code
             end
          end

         a << [data[:tce], data[:tps], data[:gpa], data[:result], data[:remarks]].join(' & ')   #"\\multirow{3}{*}{#{data[:remarks]}}"
         a << "\\\\"
          
          
          
           (@number_of_tabulation_column-1).times.each {a << ' & '}
           a << "\\\\\n"

         a << "\\hline"
        a   
    end


    def  grading_system
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

    def  abbreviations 
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
                            \\hline	 CA = Class Attendance \\\\ 
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

    def  exam_info
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

    def  course_info
      _course_info_a = <<-EOF
            \\hspace{1cm}
            \\begin{minipage}[m]{0.3\\linewidth} \\flushright
            %	\\vspace*{-1in} %\\centering 
                %{\\flushright \\bf	Serial No~:~\\sl \\\\}
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
end