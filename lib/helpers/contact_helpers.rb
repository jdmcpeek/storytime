require_relative '../../config/pony'
require 'httparty'
require_relative 'twilio_helpers'

module ContactHelpers

  def email_admins(subject, body = "[blank]")
    Pony.mail(:to => 'david.mcpeek@yale.edu',
              :from => 'david.mcpeek@yale.edu',
              :headers => { 'Content-Type' => 'text/html' },
              :subject => subject,
              :body => body)
  end

	def notify_admins(subject, body = "[blank]")
    email_admins(subject, body)
    text_body   = subject + ":\n" + body
    david = '+18186897323'
    if text_body.length < 360
      TextingWorker.perform_async(text_body, david, ENV['ST_USER_REPLIES_NO'])
    else
      TextingWorker.perform_async(subject, david, ENV['ST_USER_REPLIES_NO'])
    end
	end
end
