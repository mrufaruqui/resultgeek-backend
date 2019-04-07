class GenerateTabulationLatexV2Service < TabulationBaseService
	def perform(options={})
	    @student_type = options[:student_type]
	    @exam = options[:exam]
		@courses = Course.where(exam_uuid:@exam.uuid)
        @members = @exam.workforces.where(role:"member")
        @tabulators = @exam.workforces.where(role:"tabulator")
        @number_of_tabulation_column  = Course.where(:course_type=>"theory").count * 4 + Course.where(:course_type=>"lab").count * 2 + 7
		@hall_list = (Student.all - Student.where(hall_name:nil)).pluck(:hall_name).uniq
		@tco = Course.where(exam_uuid:@exam.uuid).sum(:credit).round
		@hall_name = ' '
		
		MyLogger.info "Writing files: " + Rails.root.join('reports/', [@exam.uuid, @student_type.to_s, 'tabulation_v2.tex'].join("_")).to_s

      File.open( Rails.root.join('reports/', [@exam.uuid, @student_type.to_s, 'tabulation_v2.tex'].join("_")), 'w') do |f| 
       f.puts tabulation(options)
	  end
	 
	  @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v2') || Doc.new(exam_uuid:@exam.uuid, uuid: @student_type.to_s + 'tabulation_v2') 
	  @doc.latex_loc = 'reports/' + [@exam.uuid, @student_type.to_s, 'tabulation_v2.tex'].join("_")
	  @doc.latex_name =  ["tabulation", "sheets", "v2", @student_type.to_s ,".tex"].join("_")
	  @doc.description = ["tabulation", "sheets", @student_type.to_s ].join("_").titlecase
	  @doc.save
	 
	  true
    end
     
    def tabulation(options={})
        latex_full_preamble + tabulation_body
    end


    def tabulation_body
          tabulation_header + tabulation_table + tabulation_footer
    end

     def latex_full_preamble
        latex_preamble + latex_preamble_lhead + latex_preamble_chead + latex_preamble_rhead + tabulation_lfoot + tabulation_cfoot + tabulation_lfoot
    end



    def tabulation_header
part_a =<<-EOF
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
\\vspace*{-4ex}\\begin{longtable}{lc >{\\centering\\scshape}p{0.88in}|*{5}{c}| *{5}{c}| *{3}{c}| *{5}{c}| *{3}{c}| *{5}{c}| *{5}{c}| cc|cc |>{\\centering}p{0.5in} p{0.5in}}\\toprule\\toprule%
EOF

a=[]
a << "\\multirow{2}{*}{SL\\#}" << "\\multirow{2}{*}{ID}" << "\\multirow{2}{*}{{Name}}"
@courses.each do | course|
	if course.course_type == "theory"	
		a << "\\multicolumn{5}{c|}{#{course.display_code} (Cr: #{course.credit})}" 
	else
		a << "\\multicolumn{3}{c|}{#{course.display_code} (Cr: #{course.credit})}" 
	end
end 
a << "\\multirow{2}{*}{TCE}" << "\\multirow{2}{*}{TPS}" << "\\multirow{2}{*}{GPA}" << "\\multirow{2}{*}{\\rot{ Result }}" <<"\\multirow{2}{*}{Remark}" << "\\multirow{2}{*}{\\hspace*{3ex}{Hall}}"
part_b = a.join(" &") + "\\\\"

part_c = <<-EOF
%\\cmidrule(lr){4-8}  \\cmidrule(lr){9-13} \\cmidrule(lr){14-16} \\cmidrule(lr){17-21} \\cmidrule(lr){22-24} \\cmidrule(lr){25-29} \\cmidrule(lr){30-34} 
%& & & CA & {Final} & MO & LG   & CA & {Final} & MO & LG   & MO & LG   & CA & {Final} & MO & LG   & MO & LG   & CA & {Final} & MO & LG   & CA & {Final} & MO & LG   & & & & &  \\\\
\\midrule \\endfirsthead \\toprule\\toprule 
EOF

part_f = <<-EOF
\\multirow{2}{*}{SL\\#} & \\multirow{2}{*}{ID} & \\multirow{2}{*}{{Name}} & \\multicolumn{5}{c|}{CSE 111 (Cr: 3)} & \\multicolumn{5}{c|}{CSE 113 (Cr: 3)} & \\multicolumn{3}{c|}{CSE 114 (Cr: 2)} & \\multicolumn{5}{c|}{EEE 121 (Cr: 3)} & \\multicolumn{3}{c|}{EEE 122 (Cr: 1)} & \\multicolumn{5}{c|}{MAT 131 (Cr: 3)} & \\multicolumn{5}{c|}{STA 151 (Cr: 3)} & \\multirow{2}{*}{TCE} & \\multirow{2}{*}{TPS} & \\multirow{2}{*}{GPA} & \\multirow{2}{*}{\\rot{ Result }} & \\multirow{2}{*}{Remark}} \\\\ 
%\\cmidrule(lr){4-8}  \\cmidrule(lr){9-13} \\cmidrule(lr){14-16} \\cmidrule(lr){17-21} \\cmidrule(lr){22-24} \\cmidrule(lr){25-29} \\cmidrule(lr){30-34}
%& & & CA & {Final} & MO & LG   & CA & {Final} & MO & LG   & MO & LG   & CA & {Final} & MO & LG   & MO & LG   & CA & {Final} & MO & LG   & CA & {Final} & MO & LG   & & & & &  \\\\
EOF

part_d =<<-EOF
\\midrule \\endhead \\bottomrule \\endfoot \\endlastfoot 
% \\ifnumcomp{\\value{csvrow}}{>}{20}{}{\\toContinue} and \\ifnumcomp{\\value{page}}{<}{2}{\\toContinue}{} worked in a weird way!!
%\\csvreader[head to column names,late after line=\\csvifoddrow{\\\\[1.9ex]\\midrule\\rowcolor{white}} {\\\\[1.9ex]\\midrule\\rowcolor{gray!10}} \\ifnumcomp{\\value{csvrow}}{=}{\\realrows}{\\pagebreak\\Dummywarning} {}]{rawextra.csv}{}
% \\csvreader[head to column names,late after line=\\csvifoddrow{\\\\[1.8ex]\\midrule\\rowcolor{white}}{\\ifismultiple{\\thecsvrow}{14}{\\\\\\pagebreak}{\\\\[1.8ex]}\\midrule\\rowcolor{gray!10}}\\ifnumcomp{\\value{csvrow}}{=}{35}{\\pagebreak}{}]{rawextra.csv}{}%  ****** THIS WORKS, for integer multiple of lines
%{\\thecsvrow & \\ID & \\name & \\numtwo{\\ica} & \\numtwo{\\ifnl} & {\\itot} &  {\\ilg} &  \\numtwo{\\ips} & \\numtwo{\\iica} & \\numtwo{\\iifnl} & \\iitot & \\iilg & \\numtwo{\\iips} & \\iiitot & \\iiilg & \\numtwo{\\iiips} & \\numtwo{\\ivca} & \\numtwo{\\ivfnl} & \\ivtot & \\ivlg & \\numtwo{\\ivps} & \\vtot & \\vlg & \\numtwo{\\vips} & \\numtwo{\\vica} & \\numtwo{\\vifnl} & \\vitot & \\vilg & \\numtwo{\\vips} & \\numtwo{\\viica} & \\numtwo{\\viifnl} & \\viitot & \\viilg & \\numtwo{\\viips} & \\tce & \\numtwo{\\tps} & \\numtwo{\\gpa} & \\pf & \\rem & \\hall}
EOF

part_a + part_b + part_c + part_d
    end

def tabulation_table
#   <<-EOF
#    {\\SL & \\ID & \\name & \\numtwo{\\ica} & \\numtwo{\\ifnl} & {\\itot} &  {\\ilg} &  \\numtwo{\\ips} & \\numtwo{\\iica} & \\numtwo{\\iifnl} & \\iitot & \\iilg & \\numtwo{\\iips} & \\iiitot & \\iiilg & \\numtwo{\\iiips} & \\numtwo{\\ivca} & \\numtwo{\\ivfnl} & \\ivtot & \\ivlg & \\numtwo{\\ivps} & \\vtot & \\vlg & \\numtwo{\\vips} & \\numtwo{\\vica} & \\numtwo{\\vifnl} & \\vitot & \\vilg & \\numtwo{\\vips} & \\numtwo{\\viica} & \\numtwo{\\viifnl} & \\viitot & \\viilg & \\numtwo{\\viips} & \\tce & \\numtwo{\\tps} & \\numtwo{\\gpa} & \\pf & \\hall}
#    EOF 
  a=''
  @hall_list.each do |hall|
	@hall_name = hall
	Tabulation.where(student_type:@student_type).joins(:student).merge(Student.where(hall_name:hall)).each do |t| 
	  a<<tabulation_row(generate_single_page_tabulation(t))
	 end
	 a << '\\pagebreak'
   end
  a
end


def tabulation_footer
<<-EOF
\\end{longtable}
\\end{small}
\\endgroup
\\end{document}
        EOF
    end

	def tabulation_row(data)
		 a = ''
          a << [data[:sl_no], data[:roll], data[:name]].join(' & ') << ' & '   
          Course.all.each do |course|
            if course.course_type === "lab"
                a << [data[course.code][:mo], data[course.code][:lg]].join(' & ') << ' & ' if data.include? course.code
             else
                a << [data[course.code][:cact], data[course.code][:fem], data[course.code][:mo], data[course.code][:lg]].join(' & ') << '&' if data.include? course.code
             end
          end

         a << [data[:tce], data[:tps], data[:gpa], data[:result], data[:remarks]].join(' & ')   #"\\multirow{3}{*}{#{data[:remarks]}}"
         a << "\\\\"
          
          30.times.each {a << ' & '}
          a << "\\\\\n"
          
          30.times.each {a << ' & '}
          a << "\\\\\n"

          a << "\\hline"
        a   
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
		   70\\% to less that 75\\% &  A- & $3.50$ \\\\ 
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
        \\begin{minipage}[m][5cm][c]{2in}%
		\\begin{footnotesize}
		\\rowcolors{1}{white}{gray!10}
		\\setlength\\tabcolsep{4pt}		
		\\tcbset{colframe=gray!60,width=2in,height=5cm,colback=white,%colupper=red!5,
		fonttitle=\\bfseries,nobeforeafter}
		{\\vspace*{0.41cm}}\\tcbox[left=0mm,right=0mm,top=0mm,bottom=0mm,boxsep=0mm,title=Acromyms/Glossaries]{%
		\\renewcommand\\arraystretch{0.89}
	    \\begin{tabular}{lm{1.8in}}
		CA & Continuous Assessment marks (30\\% of total: 10\\% in attendance + 20\\% in class tests) \\\\
		MO & Marks Obtained: total marks in final (70\\%) + CA (rounded upwards)\\\\
		LG & Letter Grade (per the table on the left)\\\\
		GP & Grade Point (per the table on the left)\\\\
		Cr & Credit (per course)\\\\
		PS & Point Secured ($= \\text{GP} \\times \\text{Cr}$, per course)\\\\
		TPS & Total Points Secured ($=\\!\\sum PS$ all courses)\\\\
		TCE & Total Credit Earned\\\\
		GPA & TPS/18 (Total Credits Offered=$#{@tco}$)\\\\
		\\end{tabular}}
		\\end{footnotesize}
        \\end{minipage}%
		\\endgroup
}% end \\lhead
        EOF
    end

    def latex_preamble_chead
        <<-EOF
\\chead{%
		\\begingroup
        \\begin{minipage}[m][5cm][c]{0.8in}%
		{\\hspace*{2.0in}\\includegraphics[width=0.7in]{cu-logo.png}}
        \\end{minipage}%
        \\hspace*{2.0in}\\begin{minipage}[m][5cm][c]{5in}%
        \\raggedright\\begin{center}
		\\begin{LARGE}
		{\\textsc{University of Chittagong}}\\\\
		\\textsc{Department of Computer Science \\& Engineering}\\\\
		{{\\sc Tabulation Sheet #{ '(Improvement)' if  @gradesheet_type ==  :improvement }}}\\\\
		\\textsc{#{@exam.fullname}}\\\\
		{Held in #{@exam.held_in}}
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
		<<-EOF
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
		 Member: & #{@members[0].teacher.display_name unless @members[0].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
		 Member: & #{@members[1].teacher.display_name unless @members[1].nil? || @members.length < 2} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
	 	\\end{tabular}
		\\end{footnotesize}
		}
        \\end{minipage}%
		\\endgroup
}
        EOF
    end
   
    def tabulation_cfoot
	<<-EOF
\\cfoot{%
    % \\fbox{%
    	\\begingroup
        \\begin{center}
        \\begin{minipage}[t][2.5cm][l]{5in}%
		\\tcbset{colframe=gray,colback=white,%colupper=red!5,
		fonttitle=\\bfseries,nobeforeafter}
		{\\vspace*{0.2cm}}\\tcbox[left=0mm,right=0mm,top=0.2mm,bottom=1.5mm,boxsep=0mm,title=Tabulators]{%
		\\renewcommand\\arraystretch{1.3}
		\\begin{footnotesize}
	    \\begin{tabular}{rll}
		 1. & #{@tabulators[0].teacher.display_name unless @tabulators[0].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt} \\\\
		 2. & #{@tabulators[1].teacher.display_name unless @tabulators[1].nil?} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt}	\\\\
		 3. & #{@tabulators[2].teacher.display_name unless @tabulators[2].nil? || @tabulators.length < 3} & \\hdashrule[-0.5ex]{2cm}{1pt}{1pt}\\\\
		\\end{tabular}
		\\end{footnotesize}
		}
		\\tcbset{colframe=gray,colback=white,%colupper=red!5,
		fonttitle=\\bfseries,nobeforeafter}
        \\hfill{\\vspace*{-0.45cm}\\tcbox[left=0mm,right=1mm,top=1cm,minipage,width=1.2in,height=1.2cm,bottom=2mm,boxsep=0mm,title=Date of Publication]{}}%\\framebox(100,15){}}\\vfill%
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
        \\tcbox[minipage,width=1.8in,height=0.7in,left=0mm,right=0mm,top=5mm,bottom=0mm,boxsep=0mm,title=Controller of Examination]{}%}\\hfill
        \\hfill\\tcbox[minipage,width=1.8in,height=0.7in,left=0mm,right=0mm,top=0mm,bottom=0mm,boxsep=0mm,title=Vice-Chancellor]{}%}\\hfill
        \\end{minipage}%
        \\endgroup
}
EOF
    end
    
    
end