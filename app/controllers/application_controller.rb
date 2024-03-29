require 'net/https'

class ApplicationController < ActionController::Base
  before_action :record_page_view
  add_flash_types :danger, :info, :warning, :success, :messages

  RECAPTCHA_MINIMUM_SCORE = 0.5

  def verify_recaptcha?(token, recaptcha_action)
    secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)

    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
  end

  def record_page_view
    return if request.is_crawler? || current_admin

    ActiveAnalytics.record_request(request)
  end
end
