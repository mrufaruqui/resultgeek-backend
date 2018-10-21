class ProcessingService
   def self.perform(options={})
   
       ####Remove Old Caculations####
       TabulationDetail.destroy_all
       Tabulation.destroy_all


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
                sm = Summation.find_by(student_id:s.id, course_id: c.id) || Summation.create(student_id:s.id, course_id: c.id, gpa:'X', grade:0)
               # if sm.gpa != 'X' #!sm.blank? || !sm.nil?
                    td = TabulationDetail.find_by(:tabulation_id=>tabulation.id, :summation_id=>sm.id)  || TabulationDetail.new
                        td.tabulation = tabulation
                        td.summation  = sm
                        td.save 
                        remarks << c.code if sm.gpa === 'F' 
                        tce += c.credit unless sm.gpa === 'F' || sm.gpa === 'X'
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
            tabulation.remarks = 'F-' + remarks.join(",") if tce < 18 #ToDo
            tabulation.save
       end
  end
 
  ###Format CGPA According to CU Syndicate Directions ####

  def self.format_gpa(gpa)
    third_decimal = ((gpa.round(3) - gpa.round(2)) * 1000).to_i
    fourth_decimal = ((gpa.round(4) - gpa.round(3)) * 10000).to_i
    third_decimal > 0  || fourth_decimal > 0 ? (gpa.round(2).+(0.01)).round(2) : gpa.round(2)
  end

end


#  id         :integer          not null, primary key
#  student_id :integer
#  gpa        :float(24)
#  tce        :float(24)
#  result     :string(255)
#  remarks    :string(255)