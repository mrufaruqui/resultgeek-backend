class GenerateLatexFilesJob< ApplicationJob
  queue_as :default

  def perform(options={})
    @exam = options[:exam]
    ImportFullExamService.generate_latex_files options
  end
end