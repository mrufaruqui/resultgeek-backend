class LatexToPdfJob < ApplicationJob
  queue_as :default

  def perform(options={})
   d = options[:doc]
   # Doc.where.not('latex_name LIKE ?', '%tabulation%').each do |d|
       system "pdflatex -shell-escape -output-directory=#{Rails.root.join('reports')} -no-file-line-error #{d.latex_loc}"
       save_to_db(d)
   #  end
   true
  end

  def save_to_db (doc)
       d = Doc.find_by(:id=>doc.id) 
       d.pdf_loc  = d.latex_loc.sub(".tex", ".pdf")
       d.pdf_name = d.latex_name.sub(".tex", ".pdf")
       d.pdf_str = Base64.encode64(File.open(Rails.root.join(d.pdf_loc), "rb").read)
       d.save
      true
  end

end
