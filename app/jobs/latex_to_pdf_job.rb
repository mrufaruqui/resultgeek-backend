class LatexToPdfJob < ApplicationJob
  queue_as :default

  def perform(options={})
   d = options[:doc]
   # Doc.where.not('latex_name LIKE ?', '%tabulation%').each do |d|
       exec "pdflatex  -no-file-line-error #{d.latex_loc} -output-directory=./reports/"
   #    d.pdf_loc = d.latex_loc.split(".")[0] + '.pdf'
  #     d.pdf_name = d.latex_name.split(".")[0] + '.pdf'
   #    d.save
   #  end
  end
end
