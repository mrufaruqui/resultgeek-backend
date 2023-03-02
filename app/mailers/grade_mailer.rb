class GradeMailer < ApplicationMailer

    include Resque::Mailer 

    @queue='saplmailer'
 
   def  send_grade(options={}) 
     if options[:attachment_name].present?
      attachments[options[:attachment_name]] = File.read(options[:filename]) if  File.exist? (options[:filename])
     end
     mail(to: options[:recipents], 
          cc: options[:cc], 
          subject: options[:subject],
          body: options[:body]
          )
   end
   
   def self.perform(options={})
        send_grade(options).deliver
   end
end
