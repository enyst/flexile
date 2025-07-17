# frozen_string_literal: true

class UserPresenter
  def initialize(user)
    @user = user
  end

    def present
        if @user.is_a?(ActiveRecord::Relation)
            @user.map { |user| format_user(user) }
        else
            format_user(@user)
        end
    end

  def logged_in_user
    format_user(@user)
  end

  private

  def format_user(user)
    {
      id: user.external_id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      company_id: user.company_id
    }
  end
end
