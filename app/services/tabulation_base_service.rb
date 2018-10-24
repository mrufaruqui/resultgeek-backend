class TabulationBaseService
    ######For each Tabulation.includes(:tabulation_details) generate a single row########
  def generate_single_page_tabulation(t) 
        @retHash = Hash.new
        @retHash[:sl_no] = t.sl_no
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
        @retHash[:tps] = tps; 
        @retHash
      end    

end
