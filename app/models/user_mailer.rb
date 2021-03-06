class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += "#{user.first_name}, please activate your new account"
  
    @body[:url]  = "http://www.myquotable.com/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.myquotable.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@myquotable.com"
      @subject     = "MyQuotable: "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
