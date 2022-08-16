require 'oembed'

class EmbedsController < ApplicationController
  # protect_from_forgery
  def index
    @embed = Embed.find_or_create_by(url: params[:url])
    if @embed.present?
      content = render_to_string(
        partial: @embed.to_trix_content_attachment_partial_path,
        locals: { @embed.class.name.underscore.to_sym => @embed }
      )
      render json: { sgid: @embed.attachable_sgid, content: content }
    else
      render json: {}, status: :unprocessable_entity
    end
  rescue OEmbedError => e
    Rails.logger.error e
    render json: {}, status: :unprocessable_entity
  end
end
