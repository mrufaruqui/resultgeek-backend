json.extract! summation, :id, :assesment, :attendance, :cact, :section_a_code, :section_b_code, :marks, :percetage, :section_a_marks, :section_b_marks, :total_marks, :gpa, :grade
json.extract! summation.student, :roll, :name
json.url summation_url(summation, format: :json)
