class ProcessRegularJob< ApplicationJob
  queue_as :default

  def perform(options={})
    @exam = options[:exam]
    ImportFullExamService.process_result_regular options
  end
end