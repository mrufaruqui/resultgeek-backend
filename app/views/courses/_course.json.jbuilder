json.extract! course, :id, :section_a_marks, :section_b_marks, :attendance, :assesment, :grade, :marks, :total_marks, :percentage, :created_at, :updated_at
json.url course_url(course, format: :json)
