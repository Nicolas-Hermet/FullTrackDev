class StaticPagesController < ApplicationController
  def landing
  end

  def contact
    redirect_to root_path, success: 'Message envoyé !'
  end
end
