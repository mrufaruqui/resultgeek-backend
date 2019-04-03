# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'rokan@cu.ac.bd', nickname: 'Rokan', name: 'Rokan Faruqui', password: "1234qwer")
Exam.create(sem: :_sixth, year: "2018", program: "bsc", title: "", uuid: "_sixthbsc2018")
@exam = Exam.find_by(uuid: "_sixthbsc2018")

Course.create(code:'CSE611',	title:'Computer Interfacing and Microcontroller', credit:3, exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE612',	title:'Computer Interfacing and Microcontroller Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE613',	title:	'Computer Networks', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE114',	title:	'Computer Networks Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE615',	title:	'Web Engineering', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE116',	title:	'Web Engineering Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE617',	title:	'Theory of Computation', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'CSE118',	title:	'Mobile Apps Development Lab', credit:2, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'EEE621',	title:	'Electrical Engineering', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)
Course.create(code:'EEE622',	title:	'Electrical Engineering Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)
 
Course.find_by(code:'CSE611').update(sl_no:1)
Course.find_by(code:'CSE612').update(sl_no:2)
Course.find_by(code:'CSE613').update(sl_no:3)
Course.find_by(code:'CSE614').update(sl_no:4)
Course.find_by(code:'CSE615').update(sl_no:5)
Course.find_by(code:'CSE616').update(sl_no:6)
Course.find_by(code:'CSE617').update(sl_no:7)
Course.find_by(code:'CSE618').update(sl_no:8)
Course.find_by(code:'EEE621').update(sl_no:9)
Course.find_by(code:'EEE622').update(sl_no:10) 


#Dept.create(code:'CSE', name:'Computer Science and Engineering')

 
#Teacher.create(title:'Mr.', fullname:'Rokan Uddin Faruqui', designation: :associate_professor, email:'rokan@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr.', fullname:'Hanif Siddiki', designation: :associate_professor, email:'hanif@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Mr.', fullname:'Nihad Karim Chowdhury', designation: :associate_professor, email:'nihad@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Mr.', fullname:'A. H. M Sajedul Hoque', designation: :assistant_professor, email:'hoque.cse@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))

 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Hanif%'), role: "chairman") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nihad%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Hanif%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nihad%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")

#####Student registration###############
Student.all.each { |s| Registration.create(student:s, exam:@exam, exam_uuid:@exam.uuid, student_type:"regular") }

@hall_list = (Student.all - Student.where(hall_name:nil)).pluck(:hall_name).uniq

@hall_list.each do |hall|
    Tabulation.joins(:student).merge(Student.where(hall_name:hall)).each do |tab|
         tab.update(sl_no:i)
         i = i+1;
    end
end

# Course.create(code:'CSE111',	title:'Introduction to Computer Systems and Computing Agents', credit:3)
# Course.create(code:'CSE113',	title:	'Structured Programming Language', credit: 3)
# Course.create(code:'CSE114',	title:	'Structured Programming Language Lab', credit:2, course_type:"lab")
# Course.create(code:'EEE121',	title:	'Electrical Engineering', credit: 3)
# Course.create(code:'EEE122',	title:	'Electrical Engineering Lab', credit:1, course_type:"lab")
# Course.create(code:'MAT131',	title:	'Matrices, Vector Analysis and Geometry', credit:3)
# Course.create(code:'STA151',	title:	'Basic Statistics', credit:	3)

# Course.create(sl_no:1, code:'CSE311', title:'Data Structures', credit:3, exam_uuid:'_thirdbsc2017', exam: @exam)
# Course.create(sl_no:2, code:'CSE312', title:'Data Structures Lab', credit:1, exam_uuid:'_thirdbsc2017', exam: @exam, course_type:"lab")


#Course.update(exam_uuid:@exam.uuid)
#Summation.update(exam_uuid:@exam.uuid)