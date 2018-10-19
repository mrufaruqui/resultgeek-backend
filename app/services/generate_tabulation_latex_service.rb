class GenerateTabulationLatexService
   
    def self.create_tabulation_latex(options={})
         options = generate_tabulation_view
         perform(options)
    end

    def self.perform(options={})
    File.open(File.join('./reports/', 'tabulation.tex'), 'w') do |f| 
       f.puts latex_tabulation_template(options)
      end
    end

    def self.latex_tabulation_template(options) 
          header = tabulation_header
          main = ''
          main << main_preamble() 
          options.first(5).each do |data| 
                   main << course_body(data) 
           end
           main << main_footer()
           footer = tabulation_footer

         header + main + footer
    end

    def self.generate_tabulation_view(options={})
      a = []
      @tab = Tabulation.all
      @tab.each do |t| 
        @retHash = Hash.new
        @retHash[:gpa] = t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = t.student.roll
        @retHash[:name] = t.student.name
        @retHash[:hall] = t.student.hall_name;
        @retHash[:courses] = []
        tps = 0.0;
        t.tabulation_details.each do |td|
            ps = ( td.summation.course.credit.to_f * td.summation.grade.to_f).round(2)
            if td.summation.course.course_type === "lab"
              course =  {:course_type=>"lab", :code=> td.summation.course.id, :mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            else
               course = {:course_type=>"theory", :code=> td.summation.course.id, :cact=>td.summation.cact, :fem=>td.summation.marks, :mo=>td.summation.total_marks, :lg=>td.summation.gpa, :gp=>td.summation.grade, :ps=>ps }
            end  
            tps += ps;
            @retHash[:courses] << course
        end
        @retHash[:tps] = tps;
        puts @retHash
        a << @retHash
      end
      a
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
         <<-EOF 
         \\begin{table}[ht]
\\begin{minipage}[m]{0.3\\linewidth} %\\centering
\\vspace*{-3.0cm} 
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
\\textsc{$5^{th}$ Semester B.Sc. Engineering Examination 2016}\\\\
{Held in December 2016 - January 2017}\\\\
\\end{minipage}
\\hspace{0.2cm}
\\begin{minipage}[m]{0.3\\linewidth} \\flushright
\\vspace*{-1in} %\\centering 
%{\\flushright \\bf	Serial No:\\sl \\\\}
%\\vspace{4mm}
\\begin{small}
\\renewcommand{\\arraystretch}{1.01}
\\begin{tabular} {|l|l|r|r|}
	\\hline \\hline Code & Title  & Credit &  Marks \\\\ \\hline
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline CSE 111 & Computer Fundamentals  & 3.00 & 75 \\\\
	\\hline
\\end{tabular}
\\end{small} 
\\end{minipage}
\\end{table}
\\vspace*{-0.5cm}
\\begin{center}
	%\\hspace*{1in}
	\\renewcommand{\\arraystretch}{1.08}
	
	\\begin{small}
\\begin{tabular}{|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|l|c|c|c|} \\hline
	\\bf  \\bf ID No. & \\bf Student Name &\\multicolumn{4}{c|}{\\textbf{CSE 111}}  & \\multicolumn{4}{c|}{\\textbf{CSE 113}} & \\multicolumn{2}{c|}{\\textbf{CSE 114}} & \\multicolumn{4}{c|}{\\textbf{EEE 121}} & \\multicolumn{2}{c|}{\\textbf{EEE 122}} &  \\multicolumn{4}{c|}{\\textbf{MAT 131}} & \\multicolumn{4}{c|}{\\textbf{STA 151}} & TCE & TPS & Result & Remarks \\\\ \\hline
	 
    &   & CATM & FEM & MO & LG     & CATM & FEM & MO &  LG   & MO & LG   & CATM & FEM & MO & LG   & MO & LG   & CATM & FEM & MO & LG   & CATM & FEM & MO & LG   &  &   &   &  \\\\ \\hline
            EOF
    end

    def self.main_footer(data ={})
         <<-EOF 
            \\end{tabular}
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
                \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$
                \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$
                \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$
            \\end{enumerate} 

            \\end{minipage}
            \\hspace{2.3cm}
            \\begin{minipage}[b]{0.33\\linewidth}
            {\\centering Exam Committee}
            \\begin{enumerate}
            \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$  Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ --  Chairman
            \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$  Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$ -- Member
            \\item Name: \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$  Signature:  \\hspace*{1ex} $\\ldots \\ldots \\ldots \\ldots$-- Member
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
          a << [data[:roll], data[:name]].join('&') << '&'
          data[:courses].each do |course|
            if course[:course_type] === "lab"
               a << [course[:mo], course[:gp], course[:ps],].join('&')
            else
               a << [course[:cact], course[:fem], course[:mo], course[:gp], course[:ps],].join('&')
            end   
            # <<-EOF
            #     \\hline   #{course[:code]} &  #{course[:title]}		 & #{course[:credit]} & #{course[:lg]} & #{course[:gp]} & #{course[:ps]} \\\\ %\\numtwo{summation.gp} %\\\\ 
            # EOF
          end
          a << "\\\\\n\\hline"
        a   
    end
end