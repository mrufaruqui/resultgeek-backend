json.extract! registration, :id, :exam, :student, :student_type, :course_list, :created_at, :updated_at
json.url registration_url(registration, format: :json)
