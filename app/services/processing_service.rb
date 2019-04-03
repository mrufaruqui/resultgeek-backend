class ProcessingService
   def self.perform(options={})
       #######Retrieve exam info or default last one##########
       #@exam = (options.include? :exam_uuid) ? Exam.find_by(uuid:options[:exam_uuid]) : Exam.last
       @exam = options[:exam]
       courses = Course.where(exam_uuid:@exam.uuid)

       ####Remove Old Caculations####
       #TabulationDetail.destroy_all
       Tabulation.where(exam_uuid:@exam.uuid).destroy_all

       #######Retrieve Registered students #########
       Registration.where(exam_uuid:@exam.uuid).each do |r|
            is_failed_in_a_course = false;
            s = r.student
            tabulation = Tabulation.find_by(student_id:s.id) || Tabulation.new
            tabulation.student_id = s.id;
            tabulation.exam_uuid = @exam.uuid
            tabulation.sl_no = r.sl_no
            tabulation.student_type = r.student_type.to_sym
            tps = 0.0
            tce = 0.0
            remarks = []
            sm_a = []
            courses.each do |c|
                sm = Summation.find_by(student_id:s.id, course_id: c.id) || Summation.create(student_id:s.id, course_id: c.id, gpa:'X', grade:0)
               # if sm.gpa != 'X' #!sm.blank? || !sm.nil?
                    td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>sm.id)  || TabulationDetail.new
                        td.tabulation = tabulation
                        td.summation  = sm
                        td.save 
                        remarks << c.code.split(/[a-zA-Z]/).last if sm.gpa === 'F' 
                        tce += c.credit unless sm.gpa === 'F' || sm.gpa === 'X'
                        is_failed_in_a_course = true if sm.gpa === 'F'
               # end
                
                ##Generate remarks if failed 
                tps += (sm.grade * c.credit) unless sm.nil? || sm.blank? || sm.gpa === 'X' || sm.gpa === 'F'
                sm_a << sm
            end
            #tabulation.summations = sm_a;

            gpa = tps > 0 ? format_gpa(tps / 18.to_f) : 0.00
            s.gpa = gpa
            s.save
            tabulation.gpa = gpa #gpa.round(2);
            tabulation.tce = tce.to_i
            tabulation.result = (gpa >= 2.20) ? 'P' : 'F'
            tabulation.remarks = 'F-' + remarks.join(", ") if is_failed_in_a_course  
            tabulation.save
       end
     true  
  end
 
  ###Format CGPA According to CU Syndicate Directions ####

  def self.format_gpa(gpa)
    third_decimal = ((gpa.round(3) - gpa.round(2)) * 1000).to_i
    fourth_decimal = ((gpa.round(4) - gpa.round(3)) * 10000).to_i
    third_decimal > 0  || fourth_decimal > 0 ? (gpa.round(2).+(0.01)).round(2) : gpa.round(2)
  end

#   def self.get_tenant
#     @session = Session.find_by(uuid:current_user.session_uuid)
#     @exam = Exam.find_by(uuid: @session.exam_uuid)
#     @exam 
#   end

end
