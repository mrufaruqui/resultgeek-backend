@dept = Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CU", institute: "Unversity of Chittagong Chittagong")
#Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CUET", institute: "Chittagong University of Engineering and Technology")
#Dept.find_or_create_by(code:'ME', name:'Mechanical Engineering', institute_code:"CNEC", institute: "Chittagong National Engineering College")

@exam = Exam.create(sem: "_first", year: "2018", program: "BSc", title: "", uuid: "_firstbsc2018", dept:@dept)

#Course.delete_all
@exam = Exam.find_by(uuid: "_firstbsc2018")
Course.create(code:'CSE111',	title:  'Introduction to Computer Systems and Computing Agents', credit:3, exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'CSE113',	title:	'Structured Programming Language', credit: 3, exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'CSE114',	title:	'Structured Programming Language Lab', credit:2, course_type:"lab", exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'EEE121',	title:	'Electrical Engineering', credit: 3, exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'EEE122',	title:	'Electrical Engineering Lab', credit:1, course_type:"lab", exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'MAT131',	title:	'Matrices, Vector Analysis and Geometry', credit:3, exam_uuid: "_firstbsc2018", exam: @exam)
Course.create(code:'STA151',	title:	'Basic Statistics', credit:	3, exam_uuid: "_firstbsc2018", exam: @exam)

Course.find_by(code:'CSE111').update(sl_no:1)
Course.find_by(code:'CSE113').update(sl_no:2)
Course.find_by(code:'CSE114').update(sl_no:3)
Course.find_by(code:'EEE121').update(sl_no:4)
Course.find_by(code:'EEE122').update(sl_no:5)
Course.find_by(code:'MAT131').update(sl_no:6)
Course.find_by(code:'STA151').update(sl_no:7)


Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CU", institute: "Unversity of Chittagong Chittagong")
Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CUET", institute: "Chittagong University of Engineering and Technology")
Dept.find_or_create_by(code:'ME', name:'Mechanical Engineering', institute_code:"CNEC", institute: "Chittagong National Engineering College")

#Teacher.destroy_all
Teacher.find_or_create_by(title:'Mr.', fullname:'Rokan Uddin Faruqui', designation: :associate_professor, email:'rokan@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Kazi Ashrafuzzaman', designation: :associate_professor, email:'kazi.ashrafuzzaman@gmail.com', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Osiur Rahman', designation: :professor, email:'osiur.ukm@gmail.com', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Ms.', fullname:'Nasrin Akther', designation: :assistant_professor, email:'nasrin1219@gmail.com', dept: Dept.find_by(code:'CSE'))

# Workforce.destroy_all
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "member")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nasrin%'), role: "member")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "tabulator")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Osiur%'), role: "tabulator")

#####Student registration###############
# Student.all.each { |s| Registration.create(student:s, exam:Exam.first, exam_uuid:Exam.first.uuid, student_type:"regular") }

# @hall_list = (Student.all - Student.where(hall_name:nil)).pluck(:hall_name).uniq

# @hall_list.each do |hall|
#     Tabulation.joins(:student).merge(Student.where(hall_name:hall)).each do |tab|
#          tab.update(sl_no:i)
#          i = i+1;
#     end
# end

