class TabulationBaseService
    ######For each Tabulation.includes(:tabulation_details) generate a single row########
  def generate_single_page_tabulation(t) 
        student = Student.find_by(roll: t.student_roll)
        r = Registration.find_by(student:student)
        @retHash = Hash.new
        @retHash[:sl_no] = r.sl_no
        @retHash[:gpa] = '%.2f' % t.gpa
        @retHash[:result] = t.result
        @retHash[:tce] = '%.2f' % t.tce
        @retHash[:remarks] = t.remarks
        @retHash[:roll] = student.roll
        @retHash[:name] = student.name
        @retHash[:hall] = student.hall_name;
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
  protected
  def get_tenant(options={})
      @tenant = Tenant.last
      if @tenant
         @exam = Exam.find_by(exam_uuid: @tenant.exam_uuid) 
      else
        @exam = Exam.last;
    end
  end

end
