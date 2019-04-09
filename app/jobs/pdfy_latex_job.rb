class  PdfyLatexJob < ApplicationJob
  queue_as :default
  def perform(options={})
    Doc.where(exam_uuid:options[:exam].uuid).each do |d|
       system "xelatex -shell-escape -output-directory=#{Rails.root.join(options[:folder])} -no-file-line-error #{d.latex_loc}"
       system "rm -rf #{Rails.root.join(options[:folder])}/*.aux"
       system "rm -rf #{Rails.root.join(options[:folder])}/*.log" 
    end
   true
  end
end
