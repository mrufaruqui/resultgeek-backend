class ProcessIrregularJob< ApplicationJob
  queue_as :default

  def perform(options={})
    @exam = options[:exam]
    ImportFullExamService.full_process_result_irregular options
  end
end