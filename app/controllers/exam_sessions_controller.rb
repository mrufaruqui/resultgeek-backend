class ExamSessionsController < DeviseTokenAuth::SessionsController

 def create
    super do |resource|
      puts 'printing resources'
      puts resource.id
      puts resource.email
      session[:exam_uuid] = Exam.first.uuid
      puts session[:exam_uuid]
    end
  end

end
