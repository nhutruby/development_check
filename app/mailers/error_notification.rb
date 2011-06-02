class ErrorNotification < ActionMailer::Base
  default :from => "errors@itoursmart.com"

  def error_email(error)
    @error = error
    mail( :from => "errors@itoursmart.com",
      :to => "admin@itoursmart.com",
      :subject => "Protocol Error")
  end
end
