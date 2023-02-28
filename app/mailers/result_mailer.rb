class ResultMailer < ApplicationMailer
   def email_indiviual_result(options)
       mail(to: options[:recipents], subject: options[:subject], content_type:'text/html; charset=UTF-8', body: options[:body] )
   end 
end