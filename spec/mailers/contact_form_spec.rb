require "rails_helper"

RSpec.describe ContactFormMailer, type: :mailer do
  let(:message) { 'Hello there !' }
  let(:params) do
    { name: 'visitor', visitor: 'visitor@example.com', message: message }
  end
  let(:mail) { described_class.with(params).message_email }

  it 'sends the correct information' do
    # allow(:params).to receive(:name).and_return('visitor')
    expect(mail.to).to eq(['nico@fulltrack.dev'])
    expect(mail.from).to eq(['no-reply@fulltrack.dev'])
    expect(mail.subject).to include('has a question')
    expect(mail.body).to include(message)
  end
end
