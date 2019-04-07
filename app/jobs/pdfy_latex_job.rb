class  PdfyLatexJob < ApplicationJob
  queue_as :default
  def perform(options={})
    Doc.where(exam_uuid:options[:exam].uuid).each do |d|
       system "xelatex -shell-escape -output-directory=#{Rails.root.join('reports')} -no-file-line-error #{d.latex_loc}"
       system "rm -rf #{Rails.root.join('reports')}/*.aux"
       system "rm -rf #{Rails.root.join('reports')}/*.log" 
    end
   true
  end
end
