@dept = Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CU", institute: "Unversity of Chittagong Chittagong")
Exam.create(sem: :_fifth, year: "2021", program: "bsc", title: "", uuid: "_fifthbsc2021", dept:@dept)

@exam = Exam.find_by(uuid: "_fifthbsc2021")


Teacher.create(title:'Dr', fullname:'Rudra Pratap Deb Nath', designation: :assistant_professor, email:'rudra@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr', fullname:'Md. Mahbubul Islam', designation: :lecturer, email:'istiak@cu.ac.bd', dept: Dept.find_by(code:'CSE'))

 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Kazi%'), role: "chairman") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rudra%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Mahbubul%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Kazi%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rudra%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Mahbubul%'), role: "tabulator")
