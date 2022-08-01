class StaticPagesController < ApplicationController
  def landing; end

  def home
    @articles = Article.where(status: :published).with_rich_text_content_and_embeds.sample(3)
  end

  def contact
    unless verify_recaptcha?(params[:recaptcha_token], 'contact')
      flash.now[:error] = "reCAPTCHA Authorization Failed. Please try again later."
      return render :landing, anchor: 'hire'
    end
    ContactFormMailer.with(params).message_email.deliver_now
    redirect_to static_pages_landing_path
  end
end
