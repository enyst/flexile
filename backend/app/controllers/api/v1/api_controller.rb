# frozen_string_literal: true

class Api::V1::ApiController < Api::V1::BaseController
  include Clerk::Authenticatable

  before_action :authenticate_user!

  private

  def authenticate_user!
    head :unauthorized unless clerk_user
  end

  def current_user
    @current_user ||= User.find_by(clerk_id: clerk_user.id)
  end

  def clerk_user
    @clerk_user ||= request.env['clerk'].user
  end
end
