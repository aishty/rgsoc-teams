class ApplicationFormMailer < ActionMailer::Base
  include ApplicationHelper
  default from: ENV['EMAIL_FROM'] || 'summer-of-code-team@railsgirls.com'
  default to: 'summer-of-code@railsgirls.com'

  def new_application(application)
    @application = application
    mail(subject: "[RGSoC #{current_year}] New Application: #{@application.name}")
  end
end
