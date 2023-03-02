@dept = Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CU", institute: "Unversity of Chittagong Chittagong")

#@exam = Exam.find_or_create_by(sem: :_seventh, year: "2021", program: "bsc", title: "", uuid: "_seventhbsc2021", detpt:@dept)

@exam = Exam.find_by(uuid: "_seventhbsc2021")

Teacher.find_or_create_by(title:'', fullname:'Muhammad Anuwarul Azim', designation: :professor, email:'azim@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Kazi Ashrafuzzaman', designation: :professor, email:'ashraf@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr', fullname:'Abu Nowshed Chy', designation: :assistant_professor, email:'nowshed@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))


Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "member")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Azim%'), role: "member")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nowshed%'), role: "member")

Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Azim%'), role: "tabulator")
Workforce.find_or_create_by(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nowshed%'), role: "tabulator")
