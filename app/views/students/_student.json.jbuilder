json.extract! student, :id, :name, :roll, :hall, :hall_name, :gpa, :status, :created_at, :updated_at
json.url student_url(student, format: :json)
