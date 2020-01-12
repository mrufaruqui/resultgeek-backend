@exam = Exam.find_by(uuid: "_seventhbsc2019")

c1 = Course.create(code:'CSE611',	title:'Computer Interfacing and Microcontroller', credit:3, exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE612',	title:'Computer Interfacing and Microcontroller Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE613',	title:	'Computer Networks', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE614',	title:	'Computer Networks Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE615',	title:	'Web Engineering', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE616',	title:	'Web Engineering Lab', credit:1, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE617',	title:	'Theory of Computation', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'CSE618',	title:	'Mobile Apps Development Lab', credit:2, course_type:"lab", exam_uuid: "_sixthbsc2018", exam: @exam)

Course.create(code:'EEE621',	title:	'Electrical Engineering', credit: 3, exam_uuid: "_sixthbsc2018", exam: @exam)

Course.find_by(code:'CSE611').update(sl_no:1)
Course.find_by(code:'CSE612').update(sl_no:2)
Course.find_by(code:'CSE613').update(sl_no:3)
Course.find_by(code:'CSE614').update(sl_no:4)
Course.find_by(code:'CSE615').update(sl_no:5)
Course.find_by(code:'CSE616').update(sl_no:6)
Course.find_by(code:'CSE617').update(sl_no:7)
Course.find_by(code:'CSE618').update(sl_no:8)
Course.find_by(code:'EEE621').update(sl_no:9) 


Dept.find_or_create_by(code:'CSE', name:'Computer Science and Engineering')

 
Teacher.find_or_create_by(title:'', fullname:'Rokan Uddin Faruqui', designation: :associate_professor, email:'rokan@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Kazi Ashrafuzzaman', designation: :associate_professor, email:'ashraf@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Rashed Mustafa', designation: :associate_professor, email:'nihad@cu.ac.bd', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'', fullname:'A. H. M. Sajedul Hoque', designation: :assistant_professor, email:'hoque.cse@cu.ac.bd ', dept: Dept.find_by(code:'CSE'))
Teacher.find_or_create_by(title:'Dr.', fullname:'Asaduzzaman', designation: :professor, email:'asaduzzaman@cuet.ac.bd ', dept: Dept.find_by(code:'CSE', institute_code: 'CUET'))

 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "chairman") 
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rashed%'), role: "member")
Workforce.create(exam_uuid:@exam.uuid, exam_id:@exam.id, teacher: Teacher.find_by('fullname LIKE ?', '%Asaduzzaman%'), role: "external_member")

Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "tabulator")
Workforce.create(exam_uuid:@exam.uuid, exam:@exam, teacher: Teacher.find_by('fullname LIKE ?', '%Sajedul%'), role: "tabulator")

#  CourseWorkforce.create(exam_uuid:e.uuid, course_id:c.id, teacher: Teacher.find_by('fullname LIKE ?', '%Rokan%'), role: "section_a_examiner")
#  CourseWorkforce.create(exam_uuid:e.uuid, course_id:c.id, teacher: Teacher.find_by('fullname LIKE ?', '%Ashraf%'), role: "section_b_examiner")
