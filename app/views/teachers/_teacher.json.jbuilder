json.extract! teacher, :id, :title, :fullname, :designation, :detp_id, :address, :email, :phone, :status
json.url teacher_url(teacher, format: :json)
