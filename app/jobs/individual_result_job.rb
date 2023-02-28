class IndividualResultJob < ApplicationJob
  queue_as :default

  def perform(options)
    results= GenerateGradeSheetService.generate_gs_view({:exam=>options[:exam],:student_type=>options[:student_type], :record_type=>:current, :folder=>   options[:folder]})
    results
  end
end
