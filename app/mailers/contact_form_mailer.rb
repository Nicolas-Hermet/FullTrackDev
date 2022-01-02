class ContactFormMailer < ApplicationMailer
  default from: "no-reply@fulltrack.dev"

  def message_email
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    mail(to: 'nico@fulltrack.dev', suject: 'A customer has a question')
  end
end
