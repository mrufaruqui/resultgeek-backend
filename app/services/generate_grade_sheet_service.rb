class GenerateGradeSheetService
    def self.perform(options={})
  #    File.open(File.join(directory, 'file.rb'), 'w') do |f|
   File.open('gs.tex', 'w') do |f|
       f.puts "\documentclass[11pt]{article}"
      end
    end

    def self.latex_gs_template(data) 
     <<-EOF 
     '\documentclass[11pt]{article}' +
     ' \usepackage[paperwidth=30cm, paperheight=21cm,left=0.78in,top=0.25in,right=0.3in,bottom=0.2in]{geometry}'
      \setlength\parskip{0pt} \usepackage{datatool} \usepackage{calc} \usepackage{array,tabularx} \usepackage{graphicx,pgf} \usepackage{utopia} \usepackage[T1]{fontenc} \usepackage{ifthen} \pagestyle{empty} \usepackage{xstring} \usepackage{multirow} \newcommand*{\numtwo}[1]{\pgfmathprintnumber[ fixed, precision=2, fixed zerofill=true]{#1}} %\newcommand{\xgpps}[2]{\ifthenelse{\equal{#1}{X}}{$\cdots$}{#2}} \begin{document} \DTLloaddb{tabulation}{1st-tabulation-csv.csv} %\DTLloaddb{tabulation}{csv-tabulation.csv} \DTLforeach*{tabulation}{\sl=SL,\roll=ID,\name=NAME, \onelg =LG111, \onegp =GP111, \oneps =PS111, \twolg =LG113, \twogp =GP113, \twops =PS113, \threelg =LG114, \threegp =GP114, \threeps =PS114, \fourlg =LG121, \fourgp =GP121, \fourps =PS121,\fivelg =LG122, \fivegp =GP122, \fiveps =PS122, \sixlg =LG131, \sixgp =GP131, \sixps =PS131, \sevenlg =LG151, \sevengp =GP151, \sevenps =PS151,\tce=TCE,\tps=TPS,\gpa=GPA, \result=RESULT, \hall =HALL}{% \begin{table}[ht] \begin{minipage}[m]{0.3\linewidth} %\centering \vspace*{-3.0cm} \begin{tabular}{l >{\hspace*{-1.8ex}}p{2.6in}} % >{\raggedleft}m{1.5in}} Name &: \textsc{\name}\\ Session &: \IfSubStr{\roll}{1770}{$2017-2018$}{$2018-2019$}\\ Roll/ID No. &: $\roll $\\ Hall &: \hall\\ \end{tabular} \end{minipage} \hspace{0.3cm} \begin{minipage}[b]{0.35\textwidth} \vspace*{.5in} \centering \includegraphics[width=0.6in]{cu-logo.jpg} \smallskip \noindent {\textsc{University of Chittagong}}\\ \textsc{Department of Computer Science \& Engineering}\\ \smallskip {\large {\sc Grade Sheet}}\\ \smallskip \textsc{$1^{st}$ Semester B.Sc. Engineering Examination 2018}\\ {Held in May - June 2018}\\ \end{minipage} \hspace{0.2cm} \begin{minipage}[m]{0.3\linewidth} \flushright \vspace*{-1.5in} %\centering {\flushright \bf Serial No:\sl \\} \vspace{4mm} \begin{small} \renewcommand{\arraystretch}{1.01} \begin{tabular}{ |c|>{\centering}m{0.9cm}|m{0.91cm}|}%| c | >{\centering}p{1cm} | >{\centering}p{1cm} |} \hline {\bf Numerical Range} & {\bf Letter Grade} & {\bf Grade Point} \\ \hline 80\% and above & A+ & $4.00$ \\ \hline 75\% to less than 80\% & A & $3.75$\\ \hline 70\% to less than 75\% & A- & $3.50$ \\ \hline 65\% to less than 70\% & B+ & $3.25$\\ \hline 60\% to less than 65\% & B & $3.00$\\ \hline 55\% to less than 60\% & B- & $2.75$\\ \hline 50\% to less than 55\% & C+ & $2.50$\\ \hline 45\% to less than 50\% & C & $2.25$\\ \hline 40\% to less than 45\% & D & $2.00$\\ \hline Less than 40\% & F & $0.00$\\ \hline Incomplete/Absent & X & X\\ \hline \end{tabular} \end{small} \end{minipage} \end{table} \vspace*{-0.5cm} \begin{center} %\hspace*{1in} \renewcommand{\arraystretch}{1.08} \begin{tabular}{|c|l|c|>{\scshape}c|c|c|} \hline \rule[-1ex]{0pt}{3.5ex} {\centering{\bf Course Code}} & \multicolumn{1}{c|}{\textbf{Course Title}} & {\bf Credits} & {\bf Letter Grade} & {\bf Grade Point} & {\bf Point Secured} \\ \hline CSE 111 & Introduction to Computer Systems and Computing Agents & $3$ & \onelg & \numtwo{\onegp} & \numtwo{\oneps} \\ \hline CSE 113 & Structured Programming Language & $3$ & \twolg & \numtwo{\twogp} & \numtwo{\twops} \\ \hline CSE 114 & Structured Programming Language Lab & $2$ & \threelg & \numtwo{\threegp} & \numtwo{\threeps}\\ \hline EEE 121 & Electrical Engineering & $3$ & \fourlg & \numtwo{\fourgp} & \numtwo{\fourps} \\ \hline EEE 121 &Electrical Engineering Lab & $1$ & \fivelg & \numtwo{\fivegp} & \numtwo{\fiveps} \\ \hline MAT 131 & Matrices, Vector Analysis and Geometry & $3$ & \sixlg & \numtwo{\sixgp} & \numtwo{\sixps} \\ \hline STA 151 & Basic Statistics & $3$ & \sevenlg & \numtwo{\sevengp} & \numtwo{\sevenps} \\ %\hline CSE 151 & English & $3$ & \fiveonelg & $\cdots$ & $\cdots$\\ \hline \end{tabular} %\end{small} \end{center} %\end{minipage} %\hspace*{3ex} %\begin{minipage}[t]{0.35\linewidth} \renewcommand{\arraystretch}{1.03} %\vspace{-0.6 cm} %\vspace*{1cm} \begin{center} \begin{tabular}{p{1.5in} >{\raggedright}p{1.6in} p{0.1in} >{\raggedright}p{2.8in} >{\raggedleft}p{1.0in}} Credits Offered: $18$ & Credits Earned: $\tce$ & & Grade Point Average (GPA): \fbox{\bf~\numtwo{\gpa}~} & Result: \fbox{\bf~{\result}~} \\ \end{tabular} \end{center} % %\vspace*{-0.4cm} \vspace{1cm} \centering\begin{table}[hb] \begin{minipage}[b]{0.33\linewidth} %\centering \noindent Date of Publication : \hspace*{1ex} $\ldots \ldots \ldots \ldots$\bigskip \vspace*{1ex} \smallskip \noindent Date of Issue \hspace*{6ex}: \hspace*{1ex} $\ldots \ldots \ldots \ldots$ \end{minipage} \hspace{2.3cm} \begin{minipage}[b]{0.33\linewidth} \noindent Prepared By \hspace*{1.3ex}: \hspace*{1ex} $\ldots \ldots \ldots \ldots$\bigskip \vspace*{1.5ex} \smallskip \noindent Compared By : \hspace*{1ex} $\ldots \ldots \ldots \ldots$ \end{minipage} \hspace*{1.2cm} \begin{minipage}[b]{0.19\linewidth} \centering Controller of Examinations \hspace*{1ex} University of Chittagong \end{minipage} \end{table} \clearpage } 
     \end{document} 
     EOF
    end

end


# {info[:permittedDepotName]}