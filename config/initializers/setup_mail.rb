require "development_mail_interceptor"
ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "itoursmart.com",  
  :user_name            => "admin@itoursmart.com",  
  :password             => "ch@ng3th3w0r1d",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}  

ActionMailer::Base.default_url_options[:host] = "itoursmart.com" if Rails.env.production?
ActionMailer::Base.default_url_options[:host] = "localhost:3000" if Rails.env.development?
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?