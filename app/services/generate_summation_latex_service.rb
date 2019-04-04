
############Call follwing funtion to generate summations for all courses defaul exam#####
#######  GenerateSummationLatexService.new.perform
######   GenerateSummationLatexService.new({uuid: exam_uuid}).perform

class GenerateSummationLatexService

    def perform(options={})
     @exam = options[:exam]
     @courses = Course.where(exam_uuid:@exam.uuid)
     @members = @exam.workforces.where(role:"member")
     @tabulators = @exam.workforces.where(role:"tabulator")
     summations_courses
     true
    end

    def summations_courses
         @courses.all.each  do |course|
             summation_by_course(course)
         end
    end

    def summation_by_course(course)
        write_to_latex_file(course)
    end

    def write_to_latex_file(course)
     File.open(Rails.root.join('reports', course.code.downcase + @exam.uuid + '_summation.tex'), 'w') do |f|
       puts "writing latex file:"
       puts Rails.root.join('reports', course.code.downcase + @exam.uuid + '_summation.tex')
       f_data = latex_summation_template(course)
       f.puts f_data

      @doc = Doc.find_by(exam_uuid:@exam.uuid, uuid: course.code.downcase + '_summation') || Doc.new(exam_uuid:@exam.uuid, uuid:course.code.downcase + '_summation') 
	  @doc.latex_loc = ['reports/', course.code.downcase + @exam.uuid + '_summation.tex'].join
      @doc.latex_name = [course.code.downcase, '_summation.tex'].join
      @doc.latex_str = Base64.encode64(f_data)
      @doc.description = [course.code.upcase, "Summation", "Sheet"].join(" ")
	  @doc.save
      end
    end
   
    def latex_summation_template(course)
          no_sm_entries = Summation.where(course_id:course.id, exam_uuid:@exam.uuid).count
          batch_size = (no_sm_entries % 35 == 0) ? no_sm_entries / 35.to_i : (no_sm_entries / 35.to_i) + 1.to_i
          
          sm_sheet = ''
          batch_size.times.each do |item|
             a = ''
            Summation.where(course_id:course.id, exam_uuid:@exam.uuid).limit(35).offset(item* 35).each do |sm|  
               a << summation_table_row(sm) 
               a << "\\\\ \\hline \n"
             end 
             sm_sheet << summation_header(course) + a + summation_footer + tabulators_chairman_info
            end
         latex_preamble + sm_sheet + latex_footer
    end


    def summation_body
         a = ''
        Summation.where(exam_uuid:@exam.uuid).first(35).each do |sm|
          a << summation_table_row(sm) unless sm.nil? || sm.student.nil?
          a << "\\\\ \\hline \n"
        end
        a
    end

    def summation_table_row(sm)
      if sm.course.course_type == "theory"
        [sm.student.roll, sm.attendance,sm.assesment, sm.cact, sm.section_a_code, sm.section_a_marks, sm.section_b_code, sm.section_b_marks, sm.marks, sm.total_marks].join(" & ") 
      else
        [sm.student.roll, sm.total_marks].join(" & ") 
      end
    end

    def latex_preamble
        <<-EOF
         \\documentclass[12pt]{article}
            \\usepackage[a4paper, left=0.78in,top=0.25in,right=0.5in,bottom=0.2in]{geometry}
            \\setlength\\parskip{0pt}
            \\usepackage{multirow}

            \\newcommand*{\\numtwo}[1]{\\pgfmathprintnumber[
                    fixed, precision=2, fixed zerofill=true]{#1}}
            \\begin{document}
        EOF
    end

     def summation_header(course)
      a =  <<-EOF
    \\centering
    \\begin{minipage}[m]{.8\\textwidth} \\centering 
    %\\includegraphics[width=0.6in]{cu-logo.jpg}
	\\smallskip
	\\noindent {\\textsc{University of Chittagong}}\\\\
	\\textsc{Department of Computer Science \\& Engineering}\\\\
	\\textsc{ #{@exam.fullname}}\\\\
    {\\large {\\sc Summation Sheet}}\\\\  
     {\\centering #{course.code} : #{course.title}     Credit : #{course.credit} } \\\\
    \\end{minipage} 
    \\begin{center} 
	\\renewcommand{\\arraystretch}{1.08}
    \\begin{small}
    EOF
    b_theory =  <<-EOF
    \\begin{tabular}{|l|c|c|c|c|c|c|c|c|c|c|} \\hline
	\\multirow{2}{*}{ID} & 	\\multirow{2}{*}{CA}  & 	\\multirow{2}{*}{CT}  & 	\\multirow{2}{*}{CACT}  & \\multicolumn{2 }{c|}{Section A}& \\multicolumn{2 }{c|}{Section B} & 	\\multirow{2}{*}{Marks}  & 	\\multirow{2}{*}{Total Marks}  \\\\ 
	&  &  &  & Code A & Marks A & Code B & Marks B&  &  \\\\ \\hline
    EOF

    b_lab  =  <<-EOF
    \\begin{tabular}{|l|c|} \\hline
	\\multirow{2}{*}{ID} & 	 	 	\\multirow{2}{*}{Total Marks}  \\\\ 
	&     \\\\ \\hline
    EOF
     return course.course_type == "theroy" ? a + b_theory : a + b_lab 
     end

     def summation_footer
        <<-EOF
        \\end{tabular}
            \\end{small}
            \\end{center}
        EOF
     end

     def tabulators_chairman_info
     <<-EOF
  \\centering
            
            \\begin{table}[hb]
            	\\centering
            \\begin{minipage}[b]{0.5\\linewidth} %\\centering
            {\\centering Tabulators }
            \\begin{enumerate}
                \\item #{@tabulators[0].teacher.display_name unless @tabulators[0].nil?} \\hspace*{1ex} $\\ldots \\ldots  $  
                \\item #{@tabulators[1].teacher.display_name unless @tabulators[1].nil? || @tabulators.length < 2} \\hspace*{1ex} $\\ldots \\ldots  $  
                \\item #{@tabulators[2].teacher.display_name unless @tabulators[2].nil? || @tabulators.length < 3} \\hspace*{1ex} $\\ldots \\ldots $  
            \\end{enumerate} 

            \\end{minipage}
            \\hspace*{1.2cm}
            \\begin{minipage}[b]{0.4\\linewidth} \\centering
            (#{@exam.workforces.find_by(role:"chairman").teacher.display_name}) \\\\
            Chairman  \\hspace*{1ex} \\\\
           #{@exam.fullname} Committee
            \\end{minipage}
            \\end{table}
            \\clearpage
     EOF
    end

    def latex_footer
         <<-EOF
            \\clearpage
            \\end{document}
        EOF
    end
end