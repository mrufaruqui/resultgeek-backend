class ProcessFullExamJob < ApplicationJob
  queue_as :default

  def self.perform(options={})
   ImportFullExamService.perform options
  end

end