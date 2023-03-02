@dept = Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering', institute_code:"CU", institute: "Unversity of Chittagong Chittagong")
Exam.create(sem: :_fifth, year: "2021", program: "bsc", title: "", uuid: "_fifthbsc2021", dept:@dept)

@exam = Exam.find_by(uuid: "_fifthbsc2021")


Teacher.create(title:'Dr.', fullname:'Rudra Pratap Deb Nath', designation: :associate_professor, email:'rudra@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'Dr.', fullname:'Md. Mahbubul Islam', designation: :associate_professor, email:'mahabub@cu.ac.bd', dept: Dept.find_by(code:'CSE'))

 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Kazi%'), role: "chairman", sl_no:1) 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "member", sl_no:2)
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rudra%'), role: "member",sl_no:3)
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Mahbubul%'), role: "member", sl_no:4)
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Kazi%'), role: "tabulator", sl_no:1)
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rudra%'), role: "tabulator",sl_no:2)
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Mahbubul%'), role: "tabulator", sl_no:3)
