require "#{Rails.root}/lib/slack"

class SlackController < ApplicationController
  include Slack

  def send_notification
    raise CanCan::AccessDenied unless current_user.admin?

    @user = User.find(params[:id])

    # Get Slack user id by email
    get_response = SlackRequest.get('users.lookupByEmail', { email: @user.email })
    slack_user_id = get_response['user']['id']
    @message_text = "This is a friendly reminder for you to submit your monthly report on VizzTrackr :simple_smile:\nPlease click on the following link to do so: http://vizz-trackr.herokuapp.com/my-report"

    # Post Slack message
    post_body_data = "{\"channel\": \"#{slack_user_id}\", \"text\": \"#{@message_text}\"}"
    post_response = SlackRequest.post('chat.postMessage', post_body_data)
    @notification_success = post_response['ok']

    respond_to do |format|
      format.json
      format.html
      format.js
    end
  end
end
