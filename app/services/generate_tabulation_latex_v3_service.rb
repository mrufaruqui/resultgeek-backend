class GenerateTabulationLatexV3Service < TabulationBaseService

	def perform(options={})
	    @student_type = options[:student_type]
	    @exam = options[:exam]
		@folder = options[:folder]
		@courses = Course.where(exam_uuid:@exam.uuid).order(:sl_no)
        @members = @exam.workforces.where(role:"member").order(:teacher_id)
        @tabulators = @exam.workforces.where(role:"tabulator")
        @tco = @courses.where(exam_uuid:@exam.uuid).sum(:credit).round
		@number_of_tabulation_column  = @courses.where(:course_type=>"theory").count * 4 + @courses.where(:course_type=>"project").count * 4+ @courses.where(:course_type=>"lab").count * 2 + 7
		@hall_list =  Tabulation.where(exam_uuid:@exam.uuid).pluck(:hall_name).uniq
		@hall_name = ''
		f_data = tabulation(options)
		MyLogger.info "Writing files: " + Rails.root.join(@folder,[@exam.uuid, @student_type.to_s, 'tabulation_v3.tex'].join("_")).to_s
		File.open( Rails.root.join(@folder, [@exam.uuid, @student_type.to_s, 'tabulation_v3.tex'].join("_")), 'w') do |f| 
		f.puts f_data
		end
	 
	  @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v3') || Doc.new(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v3') 
	  @doc.latex_loc = @folder + [@exam.uuid, @student_type.to_s, 'tabulation_v3.tex'].join("_")
	  @doc.latex_name =  ["tabulation", "sheets", "v3", @student_type.to_s ,".tex"].join("_")
	 # @doc.latex_str =   MyCompressionService.compress f_data
	  @doc.description = ["tabulation", "sheets", @student_type.to_s ].join("_").titlecase
	  @doc.save
	 
	  true
    end
     
    def tabulation(options={})
        latex_full_preamble + tabulation_body + latex_footer
    end


	def tabulation_body
		a = ''
		@hall_list.each do |hall|
		 a << latex_preamble_chead(hall)
		 a << tabulation_header + tabulation_table(hall)  + tabulation_footer
		 a << '\\pagebreak'
		end
		a
    end

    def latex_full_preamble
        latex_preamble + latex_preamble_lhead  + latex_preamble_rhead + tabulation_lfoot + tabulation_cfoot + tabulation_rfoot
    end



	def tabulation_header 
		part_a =''

		c=[]
		c << "\\vspace*{-4ex}\\begin{longtable}{p{0.15in}>{\\centering}p{0.4in}>{\\centering\\scshape}p{0.60in}"
		@courses.each do | course|
			if course.course_type == "theory"	
				c << "*{4}{c}" 
			else
				c << "*{2}{c}" 
			end
		end 
		part_a_a = c.join("|") + "| cc|c |>{\\centering}p{0.15in} p{0.5in}p{0.5in}}\\toprule\\toprule \n"

		a=[]
		a << "\\multirow{2}{*}{\\bf SL\\#}" << "\\multirow{2}{*}{\\bf ID}" << "\\multirow{2}{*}{{\\bf Name}}"
		@courses.each do | course|
			if course.course_type == "theory"	
				a << "\\multicolumn{4}{c|}{#{course.display_code} (Cr: #{course.credit})}" 
			else
				a << "\\multicolumn{2}{c|}{#{course.display_code} (Cr: #{course.credit})}" 
			end
		end 
		a << "\\multirow{2}{*}{TCE}" << "\\multirow{2}{*}{TCP}" << "\\multirow{2}{*}{\\bf GPA}" << "\\multirow{2}{*}{\\rot{\\bf Result }}" <<"\\multirow{2}{*}{\\bf Remark}"<<"\\multirow{2}{*}{\\bf ID}"

		part_b =   a.join(" &") + "\\\\\n"

	
 


		cmd=''
		i = 4
		j = 0
		@courses.each do | course|
			if course.course_type == "theory"	
				 j = i + 3
			else
				 j = i + 1
			end
			 cmd += "\\cmidrule(lr){#{i}-#{j}}"
			 i = j + 1
		end 
		cmd <<"\n"

		a = []
		a << cmd
		a << "& "

		@courses.each do | course|
			if course.course_type == "theory"	
				a << "CA & FEM & MO & LG" 
			# elsif course.course_type == "project" or course.course_type == "thesis" 
			# 	a << "IM & EM & VM & LG" 
			else
				a << "MO & LG" 
			end
		end 
	


		part_c = a.join(" &") + "& & & & &  \\\\  \\midrule \\endfirsthead \\toprule\\toprule \n "

		part_f = part_b + a.join(" &") + " & & & &  \\\\"
		
		part_d =<<-EOF
			\\midrule \\endhead \\bottomrule \\endfoot \\endlastfoot \n
			EOF

		part_a + part_a_a + part_b + part_c + part_f + part_d + "\n"
	end

	def tabulation_table(hall)
	
		a=''
			# @hall_list.each do |hall|
				@hall_name = hall
				@tab = '' 
				options = Hash.new

				if 	@student_type == :regular
					@tab = Tabulation.where(exam_uuid:@exam.uuid, student_type:@student_type, hall_name:hall, :record_type=>:current).order(:sl_no)
					@tab.each_with_index do |t, i| 
							options[:t] = t
							result = generate_single_page_tabulation(options)
							a<<tabulation_row(result)

						 
							t.tps = result[:tps]
							t.save
							a << '\\pagebreak' if (i + 1) % 6 == 0  #and @tab.count >= 6
					end
				elsif 	@student_type == :irregular
					@tab = Tabulation.where(exam_uuid:@exam.uuid,student_type:@student_type, hall_name:hall, :record_type=>:previous).order(:sl_no)
					@tab.each do |t| 
						t_cur = Tabulation.find_by(exam_uuid:@exam.uuid, student_roll: t.student_roll,:record_type=>:current)
						t_temp = Tabulation.find_by(exam_uuid:@exam.uuid, student_roll: t.student_roll,:record_type=>:temp)
						a<<tabulation_row(generate_single_page_tabulation({:t=> t_cur, :t_temp=>t_temp, :record_type=> :temp}))
						a<<tabulation_row(generate_single_page_tabulation({:t=> t, :record_type=> :previous}))
						a << '\\pagebreak' if t.sl_no % 6 == 0 and @tab.count >= 6
					end
				elsif 	@student_type == :improvement
					@tab = Tabulation.where(exam_uuid:@exam.uuid,student_type:@student_type, hall_name:hall, :record_type=>:previous).order(:sl_no)
					@tab.each do |t| 
						t_cur = Tabulation.find_by(exam_uuid:@exam.uuid, student_roll: t.student_roll,:record_type=>:temp)
						t_temp = Tabulation.find_by(exam_uuid:@exam.uuid, student_roll: t.student_roll,:record_type=>:temp)
						options[:t_cur]  = t_cur if t_cur
						options[:t_temp] = t_temp if t_temp
						a<<tabulation_row(generate_single_page_tabulation({:t=>t, :record_type=> :current}))
						a<<tabulation_row(generate_single_page_tabulation_improvement(options))
						a << '\\pagebreak' if t.sl_no % 6 == 0 and @tab.count >= 6
					end
				end
				
			# end
		a
	end

	def tabulation_footer
		<<-EOF
		\\end{longtable} 
		EOF
	end

	def tabulation_row(data)
			a = ''
			d = ''
			a << [data[:sl_no], '{\\bf '+ data[:roll].to_s + ' }', '{\\bf ' + data[:name] + ' }'].join(' & ') << ' & '   
			d <<['','',''].join(' & ') << ' & ' 
			@courses.each do |course|
				  

				if course.course_type == "theory"
					a << [data[course.code][:cact], data[course.code][:fem], data[course.code][:mo], data[course.code][:lg]].join(' & ') << '&' if data.include? course.code
					d << ['', '', '', ''].join(' & ') << '&' if data.include? course.code
			   	else #if course.course_type == "lab"
					a << [data[course.code][:mo], data[course.code][:lg]].join(' & ') << ' & ' if data.include? course.code
					d << ['', ''].join(' & ') << ' & ' if data.include? course.code
				# else
				# 	a << [data[course.code][:section_a_marks], data[course.code][:section_b_marks], data[course.code][:cact], data[course.code][:lg]].join(' & ') << '&' if data.include? course.code
				# 	d << ['', '', '', ''].join(' & ') << '&' if data.include? course.code
		        end
			end

			a << [data[:tce], data[:tps], data[:gpa], data[:result], data[:remarks],data[:roll]  ].join(' & ')#.map{|i| "\\multirow{3}{*}{" + i.to_s + "}"}.join(' & ')
			d << ['', '', '', '', ''].join(' & ')
			
			a << "\\\\"
			d << "\\\\[10pt]"
			a  + d + d+  "\\hline" + "\n"
	end

   
    def latex_preamble
        <<-EOF
		\\documentclass[10pt,landscape]{article}
		\\usepackage[a3paper,verbose,right=0.4in,left=0.8in,top=0.8cm,foot=1.9in,textheight=7.85in]{geometry}

		\\usepackage{amsmath,amsfonts}
		\\usepackage[condensed,math]{iwona}
		\\usepackage[T1]{fontenc}

		\\usepackage{csvsimple}
		\\usepackage{calc}
		\\usepackage{array,tabularx,multirow,longtable,booktabs,colortbl}
		\\usepackage{ifthen,booktabs}
		\\usepackage{fancyhdr}
		\\usepackage[table,dvipsnames]{xcolor}
		\\usepackage{pgf,tcolorbox} 
		\\usepackage{rotating}
		\\usepackage{xstring,etoolbox,dashrule,lastpage}
		% ,kantlipsum}

		\\pagestyle{fancy}
		
		\\setlength{\\headheight}{6.0cm} % 
		\\setlength{\\footskip}{0.1pt}
		\\setlength{\\headsep}{20pt}

		\\definecolor{shada}{RGB}{250,250,250}

		\\renewcommand{\\headrulewidth}{0pt}
		\\renewcommand{\\footrulewidth}{0pt}        
		EOF
    end

    def latex_preamble_lhead
        <<-EOF
			\\lhead{%
					\\begingroup
					\\begin{minipage}[m][5cm][c]{2in}%
					\\begin{footnotesize}
					\\rowcolors{2}{gray!10}{white}
					\\setlength\\tabcolsep{2pt}
					\\setlength\\extrarowheight{0pt}
					\\flushleft\\begin{tabular}{ c>{\\centering}m{0.9cm}m{0.91cm}}%| c | >{\\centering}p{1cm} | >{\\centering}p{1cm} |}
					\\toprule \\rowcolor[gray]{0.99}\\textit{Numerical Grade} & \\textit{Letter Grade} & \\textit{Grade Point} \\\\
					\\midrule
					80\\% and above & A+ & $4.00$  \\\\ 
					75\\% to less than 80\\% &  A & $3.75$\\\\ 
					70\\% to less than 75\\% &  A- & $3.50$ \\\\ 
					65\\% to less than 70\\% &  B+ & $3.25$\\\\ 
					60\\% to less than 65\\% &  B  & $3.00$\\\\ 
					55\\% to less than 60\\% &  B- & $2.75$\\\\ 
					50\\% to less than 55\\% &  C+ & $2.50$\\\\ 
					45\\% to less than 50\\% &  C  & $2.25$\\\\
					40\\% to less than 45\\% &  D  & $2.00$\\\\
					Less than 40\\%         &  F  & $0.00$\\\\ 
					Incomplete/Absent         &  X  & $\\cdots$\\\\ 
					\\bottomrule 
					\\end{tabular}
					\\end{footnotesize}
					\\end{minipage}%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
					\\endgroup
					\\begingroup
					\\begin{minipage}[m][4cm][c]{2in}%
					\\begin{footnotesize}
					\\rowcolors{1}{white}{gray!10}
					\\setlength\\tabcolsep{4pt}		
					\\tcbset{colframe=gray!60,width=2in,height=5.25cm,colback=white,%colupper=red!5,
					fonttitle=\\bfseries,nobeforeafter}
					{\\vspace*{0.41cm}}\\tcbox[left=0mm,right=0mm,top=0mm,bottom=0mm,boxsep=0mm,title=Acronyms/Glossaries]{%
					\\renewcommand\\arraystretch{0.89}
					\\begin{tabular}{lm{1.8in}}
					CA & Continuous Assessment marks (30\\% of total: 10\\% in attendance + 20\\% in class tests) \\\\
					MO & Marks Obtained: total marks in final (70\\%) + CA (rounded upwards)\\\\
					LG & Letter Grade (per the table on the left)\\\\
					GP & Grade Point (per the table on the left)\\\\
				    Cr & Credit (per course)\\\\
					FEM & Final Exam Marks\\\\
					IM/EM/VM & Internal/External/Viva Marks \\\\
				%%	PS & Point Secured ($= \\text{GP} \\times \\text{Cr}$, per course)\\\\
					TCP & Total Credit Points ($=\\!\\sum PS$ all courses)\\\\
					TCE & Total Credits Earned\\\\
					GPA & TCP/$#{@tco}$ (Total Credits Offered=$#{@tco}$)\\\\
					\\end{tabular}}
					\\end{footnotesize}
					\\end{minipage}%
					\\endgroup
			}% end \\lhead
        EOF
    end

    def latex_preamble_chead (hall)
        <<-EOF
			\\chead{%
					\\begingroup
					\\begin{minipage}[m][5cm][c]{0.8in}%
					{\\hspace*{2.0in}\\includegraphics[width=0.7in]{cu-logo.png}}
					\\end{minipage}%
					\\hspace*{2.0in}\\begin{minipage}[m][5cm][c]{5in}%
					\\raggedright\\begin{center}
					\\begin{LARGE}
					\\textsc{Department of Computer Science and Engineering}\\\\
					{\\textsc{University of Chittagong}}\\\\
				%%	\\textsc{Subject: Mechanical Engineering}\\\\
					{{\\sc Tabulation Sheet #{ '(Improvement)' if  @student_type == :improvement }}}\\\\
					\\textsc{#{@exam.fullname}}\\\\
					{Held in #{@exam.held_in}} \\\\
				    {\\sc Hall : #{ hall }}\\\\
					\\end{LARGE}
					\\end{center}
					\\end{minipage}%
					\\endgroup
			}% end \\chead
        EOF
    end

    def latex_preamble_rhead
		part_a = <<-EOF
			\\rhead{%
			\\begingroup
			\\begin{minipage}[m][5cm][c]{3in}%
			\\begin{footnotesize}
			\\setlength\\tabcolsep{2pt}
			\\rowcolors{2}{gray!10}{white}
			\\renewcommand\\arraystretch{0.91}
			\\hspace*{-0.1in}\\begin{tabular}{ l >{\\centering}m{4.5cm} cc}
			\\toprule \\rowcolor[gray]{0.99}
			{\\it Course Code} & {\\it Course Title} & {\\it Credit} & {\\it Marks} \\\\
			\\midrule 
			EOF
		
		  part_b = ''
		@courses.each  do |course|
			part_b << [course.display_code, course.title, course.credit, course.credit * 25].join(' & ') << "  \\\\\n"
		end
		 
		part_c= 
			<<-EOF 
			\\midrule
			\\rowcolor{White} & \\multicolumn{2}{c}{\\hspace*{2.1cm} Total Credits Offered: $#{@tco}$} & \\\\
			\\bottomrule
			\\end{tabular}
			\\end{footnotesize}
			\\end{minipage}%
			\\endgroup
			}% end \\rhead
			EOF
		
		part_a + part_b + part_c
    end
    
    def tabulation_lfoot
		a = <<-EOF
					\\lfoot{%
				% \\fbox{%
					\\begingroup
					\\vspace*{0.65cm}
					\\begin{minipage}[b][2cm][c]{3in}%
					\\tcbset{colframe=gray,colback=white,%colupper=red!5,
					fonttitle=\\bfseries,nobeforeafter}
					{\\vspace*{0.02cm}}\\tcbox[left=0mm,right=0mm,top=0.2mm,bottom=1.5mm,boxsep=0mm,title=Examination Committee]{%
					\\renewcommand\\arraystretch{1.3}
					\\begin{footnotesize}
					\\begin{tabular}{rll}
					Chairman: &  #{@exam.workforces.find_by(role:"chairman").teacher.display_name}  & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
		EOF
		  b = ''
		@members.each do |member|
		  b <<	"Member: & #{member.teacher.display_name unless member.nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\"
		  end
	# b =	<<-EOF
	# 				Member: & #{@members[0].teacher.display_name unless @members[0].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
	# 				Member: & #{@members[1].teacher.display_name unless @members[1].nil? || @members.length < 2} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
	# 	EOF
		
	c =	<<-EOF
					\\end{tabular}
					\\end{footnotesize}
					}
					\\end{minipage}%
					\\endgroup
			}
		EOF
		a + b +c
    end
   
    def tabulation_cfoot
	    <<-EOF
				\\cfoot{%
					% \\fbox{%
						\\begingroup
						\\begin{center}
						\\begin{minipage}[t][2.5cm][l]{6in}%
						\\tcbset{colframe=gray,colback=white,%colupper=red!5,
						fonttitle=\\bfseries,nobeforeafter}
						{\\vspace*{0.2cm}}\\tcbox[left=0mm,right=0mm,top=0.2mm,bottom=1.5mm,boxsep=0mm,title=Tabulators]{%
						\\renewcommand\\arraystretch{1.3}
						\\begin{footnotesize}
						\\begin{tabular}{rll}
						1. & #{@tabulators[0].teacher.display_name unless @tabulators[2].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
						2. & #{@tabulators[2].teacher.display_name unless @tabulators[0].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt}	\\\\
						3. & #{@tabulators[1].teacher.display_name unless @tabulators[1].nil? || @tabulators.length < 3} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt}\\\\
						\\end{tabular}
						\\end{footnotesize}
						}
						\\tcbset{colframe=gray,colback=white,%colupper=red!5,
						fonttitle=\\bfseries,nobeforeafter}
						\\hfill{\\vspace*{-0.45cm}\\tcbox[left=0mm,right=1mm,top=1cm,minipage,width=2in,height=1.2cm,bottom=2mm,boxsep=0mm,title=Date of Publication]{}}%\\framebox(100,15){}}\\vfill%
						\\end{minipage}%
						\\end{center}
						\\endgroup
				}

			EOF
    end

    def tabulation_rfoot
		<<-EOF
			\\rfoot{%
			\\begingroup
			\\vspace*{1.cm}\\begin{minipage}[b][2cm][l]{4in}%
			\\tcbset{colframe=gray,colback=white,fonttitle=\\bfseries,nobeforeafter}
			\\tcbox[minipage,width=2.2in,height=0.7in,left=0mm,right=0mm,top=5mm,bottom=0mm,boxsep=0mm,title=Controller of Examinations]{}%}\\hfill
			%%\\hfill\\tcbox[minipage,width=1.8in,height=0.7in,left=0mm,right=0mm,top=0mm,bottom=0mm,boxsep=0mm,title=Vice-Chancellor]{}%}\\hfill
			\\end{minipage}%
			\\endgroup
			}
			\\newcommand{\\xgpps}[2]{\\ifthenelse{\\equal{#1}{X}}{X}{#2}}  

			\\newcommand*\\rot{\\rotatebox{90}}

			\\newcommand*{\\numtwo}[1]{\\ifthenelse{\\equal{#1}{X}}{X}{\\pgfmathprintnumber[fixed, precision=2, fixed zerofill=true]{#1}}}

			\\newcommand*{\\realrows}{36}

			\\newcommand\\ifismultiple[4]{%
				\\pgfmathparse{mod(#1,#2)==0} \\ifnum \\pgfmathresult=1 #3 \\else #4 \\fi
			}

			\\makeatletter
			\\def\\Dummywarning{%
			\\multicolumn{\\LT@cols}{c}{\\textsc{\\LARGE \\textcolor{red}{Don't Print This Page. This Is DUMMY. Longtable  somehow affects the arraystretch at the header/footer badly, specifically at the \\emph{last} page.}}}\\\\}
			\\makeatother
			\\makeatletter
			\\def\\toContinue{%
			\\multicolumn{\\LT@cols}{r}{ \\scriptsize Continued on the nest page $\\cdots$ }\\\\}
			\\makeatother
			\\begin{document}
			\\begingroup
			\\setlength\\LTleft{0pt}
			\\setlength\\LTright{0pt}
			\\setlength\\tabcolsep{4.65pt}
			\\setlength\\extrarowheight{3pt}
			\\begin{small}
			
			EOF
    end
	
	def latex_footer
		<<-EOF
		\\end{small}
		\\endgroup
		\\end{document}
		EOF
	end
end