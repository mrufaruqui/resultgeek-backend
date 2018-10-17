json.extract! exam, :id, :title, :sem, :year, :program, :registered_regular_students, :registered_irregular_students, :passed, :failed, :created_at, :updated_at
json.url exam_url(exam, format: :json)
