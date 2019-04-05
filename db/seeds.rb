# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'rokan@cu.ac.bd', nickname: 'Rokan', name: 'Rokan Faruqui', password: "1234qwer")
Exam.create(sem: "_first", year: "2018", program: "bsc", title: "", uuid: "_firstbsc2018")

Course.delete_all
Course.create(code:'CSE111',	title:'Introduction to Computer Systems and Computing Agents', credit:3, exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'CSE113',	title:	'Structured Programming Language', credit: 3, exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'CSE114',	title:	'Structured Programming Language Lab', credit:2, course_type:"lab", exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'EEE121',	title:	'Electrical Engineering', credit: 3, exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'EEE122',	title:	'Electrical Engineering Lab', credit:1, course_type:"lab", exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'MAT131',	title:	'Matrices, Vector Analysis and Geometry', credit:3, exam_uuid: "_firstbsc2018", exam: Exam.last)
Course.create(code:'STA151',	title:	'Basic Statistics', credit:	3, exam_uuid: "_firstbsc2018", exam: Exam.last)

Course.find_by(code:'CSE111').update(sl_no:1)
Course.find_by(code:'CSE113').update(sl_no:2)
Course.find_by(code:'CSE114').update(sl_no:3)
Course.find_by(code:'EEE121').update(sl_no:4)
Course.find_by(code:'EEE122').update(sl_no:5)
Course.find_by(code:'MAT131').update(sl_no:6)
Course.find_by(code:'STA151').update(sl_no:7)


Dept.create(code:'CSE', name:'Computer Science and Engineering')

Teacher.destroy_all
Teacher.create(title:'Mr.', fullname:'Rokan Uddin Faruqui', designation: :associate_professor, email:'rokan@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr.', fullname:'Kazi Ashrafuzzaman', designation: :associate_professor, email:'kazi.ashrafuzzaman@gmail.com', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr.', fullname:'Osiur Rahman', designation: :professor, email:'osiur.ukm@gmail.com', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Ms.', fullname:'Nasrin Akther', designation: :assistant_professor, email:'nasrin1219@gmail.com', dept: Dept.find_by(code:'CSE'))

# Workforce.destroy_all
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "member")
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Nasrin%'), role: "member")
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "tabulator")
# Workforce.create(exam_uuid:Exam.last.uuid, exam:Exam.last, teacher: Teacher.find_by('fullname LIKE ?', '%Osiur%'), role: "tabulator")

#####Student registration###############
Student.all.each { |s| Registration.create(student:s, exam:Exam.first, exam_uuid:Exam.first.uuid, student_type:"regular") }

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

# Course.create(sl_no:1, code:'CSE311', title:'Data Structures', credit:3, exam_uuid:'_thirdbsc2017', exam: Exam.first)
# Course.create(sl_no:2, code:'CSE312', title:'Data Structures Lab', credit:1, exam_uuid:'_thirdbsc2017', exam: Exam.first, course_type:"lab")


#Course.update(exam_uuid:Exam.last.uuid)
#Summation.update(exam_uuid:Exam.last.uuid)