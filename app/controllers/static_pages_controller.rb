class StaticPagesController < ApplicationController
  def landing; end

  def home
    @articles = Article.where(status: :published).with_rich_text_content_and_embeds.sample(3)
  end

  def contact
    ContactFormMailer.with(params).message_email.deliver_now
    redirect_to root_path, success: 'Message envoyé !'
  end
end
