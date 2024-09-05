class EventMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']

  def notice_event(group, event)
    @group = group
    @event = event
    @users = @group.users
    mail to: @users.pluck(:email), subject: @event.title
  end
end
