class FullTrackDevController < ApplicationController
  def home; end

  def contact; end

  def wip; end

  def landing
    render layout: false
  end
end
