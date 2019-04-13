class ProcessImprovementJob< ApplicationJob
  queue_as :default

  def perform(options={})
    @exam = options[:exam]
    ImportFullExamService.full_process_result_improve options
  end
end