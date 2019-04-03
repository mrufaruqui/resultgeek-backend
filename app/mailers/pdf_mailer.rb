class PdfMailer < ApplicationMailer
    def pdf_from_latex(options={})
        #chairman = Workforce.find_by(exam_uuid:options[:exam_uuid], role:"chairman").teacher
        
        #attachments[Doc.first.pdf_name] = File.read(Doc.first.pdf_loc)
        # mail = Mail.new do 
        #   from     'sapl.mailer@gmail.com'
        #   to        options[:recipents]
        #   subject  'New Stock Report'
        #   body     'Sample body'
        #   add_file :filename => options[:filename], :content => File.read(options[:filename])
        # end

        #  return mail
        mail(to: options[:recipents], subject: options[:subject], body: options[:body])
    end
end
