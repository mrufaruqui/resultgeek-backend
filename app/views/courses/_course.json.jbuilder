json.extract! course, :id, :title, :code, :credit, :course_type
json.url course_url(course, format: :json)
