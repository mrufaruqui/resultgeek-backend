class GenerateGsJob< ApplicationJob
  queue_as :default

  def perform(options={})
    @exam = options[:exam]
    ImportFullExamService.generate_gradesheets options
  end
end