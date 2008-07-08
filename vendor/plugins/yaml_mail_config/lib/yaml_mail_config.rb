# If the RAILS_ENV is not +test+, open up <tt>RAILS_ROOT/config/email.yml</tt>
# and set ActionMailer::Base's SMTP settings using that.
if RAILS_ENV != 'test'
  c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
    
  ActionMailer::Base.smtp_settings = {
    :address => c[RAILS_ENV]['server'],
    :port => c[RAILS_ENV]['port'],
    :domain => c[RAILS_ENV]['domain'],
    :authentication => c[RAILS_ENV]['authentication'],
    :user_name => c[RAILS_ENV]['username'],
    :password => c[RAILS_ENV]['password'],
    :tls => c[RAILS_ENV]['tls'] == "true"
  }
end