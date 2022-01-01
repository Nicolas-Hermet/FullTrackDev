class StaticPagesController < ApplicationController
  def landing
  end

  def contact
    ContactFormMailer.with(params).message_email.deliver_now
    # redirect_to root_path, success: 'Message envoyé !'
  end
end
