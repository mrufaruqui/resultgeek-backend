@exam = Exam.find_by(uuid: "_secondbsc2019ciet")

Teacher.create(title:'', fullname:'N. M. Istiak Chowdhury', designation: :lecturer, email:'istiak@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.create(title:'', fullname:'Sohrab Dastgir', designation: :principal, email:'cnecctg@gmail.com', dept: Dept.find_by(code:'ME'))

Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%stiak%'), role: "member") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%ohrab%'), role: "member") 

Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%stiak%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%ohrab%'), role: "tabulator")
