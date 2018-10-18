json.extract! course, :id, :title, :code, :credit, :created_at, :updated_at
json.url course_url(course, format: :json)
