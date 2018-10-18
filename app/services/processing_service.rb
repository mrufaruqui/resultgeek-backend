class ProcessingService
   def perform(options={})
       students = Student.all
       courses = Course.all
       students.each do |s|
            tabulation = Tabulation.find_by(student_id:s.id) || Tabulation.new
            tabulation.student = s;
            tps = 0.0
            remarks = []
            sm_a = []
            courses.each do |c|
                sm = Summation.find_by(student_id:s.id, course_id: c.id)
                #remarks << c.code if c.gpa == 'F'
                tps += (sm.grade * c.credit) unless sm.nil? || sm.blank? || sm.grade.nil? || sm.grade.blank?
                sm_a << sm
            end
            #tabulation.summations = sm_a;

            gpa = tps / 18.to_f
            s.gpa = gpa.round(2)
            s.save
            tabulation.gpa = gpa.round(2);
            tabulation.result = tabulation.gpa >= 2.20 ? 'Pass' : 'Fail'
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