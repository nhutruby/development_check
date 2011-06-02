class SystemMessageMailer < ActionMailer::Base
  default :from => "no-reply@itoursmart.com"
  
  def new_message_email(recipient)
    @recipient = recipient
    mail( :to => @recipient.user.email,
          :subject => @recipient.note.subject)
  end
end
