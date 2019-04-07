class ProcessFullExamJob < ApplicationJob
  queue_as :default

  def perform(options={})
   ImportFullExamService.perform options
  end

end