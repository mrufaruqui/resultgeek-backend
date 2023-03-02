class ApplicationMailer < ActionMailer::Base
  default from:  ENV["DefaultFrom"]  ? ENV["DefaultFrom"] : 'exam.processorcu@gmail.com'
  layout 'mailer'
end
