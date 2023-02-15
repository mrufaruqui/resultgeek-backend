Exam.create(sem: :_seventh, year: "2021", program: "bsc", title: "", uuid: "_seventhbsc2021", dept_id:2)

@exam = Exam.find_by(uuid: "_seventhbsc2021")

Teacher.create(title:'', fullname:'Muhammad Anuwarul Azim', designation: :professor, email:'azim@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr.', fullname:'Kazi Ashrafuzzaman', designation: :professor, email:'ashraf@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr', fullname:'Abu Nowshed Chy', designation: :assistant_professor, email:'nowshed@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))


Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Azim%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nowshed%'), role: "member")

Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Azim%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Nowshed%'), role: "tabulator")
