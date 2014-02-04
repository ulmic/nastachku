class ApplicationController < ActionController::Base
  include AuthHelper
  include Mobylette::RespondToMobileRequests

  helper_method :current_user, :signed_in?, :signed_as_admin?

  before_filter :deny_banned_user!

  unless (Rails.env.development?)
    rescue_from ActionView::MissingTemplate, ActiveRecord::RecordNotFound do |exception|
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end

