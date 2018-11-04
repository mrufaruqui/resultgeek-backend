class LatexToPdfJob < ApplicationJob
  queue_as :default

  def perform(options={})
   d = options[:doc]
   # Doc.where.not('latex_name LIKE ?', '%tabulation%').each do |d|
       system "pdflatex -shell-escape -output-directory=#{Rails.root.join('report/')} -no-file-line-error #{d.latex_loc}"
   #  end
   true
  end
end
