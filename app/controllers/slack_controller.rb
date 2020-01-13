class SlackController < ApplicationController
  def send_notification
    raise CanCan::AccessDenied unless current_user.admin?

    @user = User.find(params[:id])
    # Get Slack user id by email
    get_response = Slack::SlackApiHelper.get('users.lookupByEmail', email: @user.email)

    # Post Slack message
    message_text = 'This is a friendly reminder for you to submit your monthly'\
                   'report on VizzTrackr :simple_smile:\nPlease click on the following'\
                   'link to do so: http://vizz-trackr.herokuapp.com/my-report'
    post_body_data = "{\"channel\": \"#{get_response['user']['id']}\", \"text\": \"#{message_text}\"}"
    post_response = Slack::SlackApiHelper.post('chat.postMessage', post_body_data)

    if post_response['ok']
      redirect_to reporting_period_url(params[:reporting_id]),
                  status: :found,
                  notice: 'Slack notification sent successfully!'
    else
      redirect_to reporting_period_url(params[:reporting_id]),
                  status: :found,
                  alert: 'Error sending Slack notification!'
    end
  end
end
