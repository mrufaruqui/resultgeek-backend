class LatexToPdfJob < ApplicationJob
  queue_as :default

  def perform(options={})
   d = options[:doc]
   # Doc.where.not('latex_name LIKE ?', '%tabulation%').each do |d|
       system "pdflatex -shell-escape -output-directory=#{Rails.root.join('reports')} -no-file-line-error #{Rails.root.join(d.latex_loc)}"
   #  end
   true
  end
end
