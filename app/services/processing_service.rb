class ProcessingService
   def self.perform(options={})
   
       ####Remove Old Caculations####
       TabulationDetail.delete_all
       Tabulation.delete_all


       students = Student.all
       courses = Course.all
       students.each do |s|
            tabulation = Tabulation.find_by(student_id:s.id) || Tabulation.new
            tabulation.student_id = s.id;
            tps = 0.0
            tce = 0.0
            remarks = []
            sm_a = []
            courses.each do |c|
                sm = Summation.find_by(student_id:s.id, course_id: c.id)
                if !sm.blank? || !sm.nil?
                    td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>sm.id)  || TabulationDetail.new
                        td.tabulation = tabulation
                        td.summation  = sm
                        td.save 
                    if sm.gpa === 'F'
                        remarks << c.code
                    else
                        tce += c.credit
                    end
                end
                
                ##Generate remarks if failed 
                

                tps += (sm.grade * c.credit) unless sm.nil? || sm.blank? || sm.grade.nil? || sm.grade.blank?
                sm_a << sm
            end
            #tabulation.summations = sm_a;

            gpa = tps / 18.to_f
            s.gpa = gpa.round(2)
            s.save
            tabulation.gpa = gpa.round(2);
            tabulation.tce = tce.to_i
            tabulation.result = tabulation.gpa >= 2.20 ? 'Pass' : 'Fail'
            tabulation.remarks = 'F-' + remarks.join(",") if tce < 18 #ToDo
            tabulation.save
       end
  end
end


#  id         :integer          not null, primary key
#  student_id :integer
#  gpa        :float(24)
#  tce        :float(24)
#  result     :string(255)
#  remarks    :string(255)