# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    private

    def respond_with(resource, _opts = {})
      render json: { message: 'Logged in.', data: resource }, status: :ok
    end

    def respond_to_on_destroy
      current_user ? log_out_success : log_out_failure
    end

    def log_out_success
      render json: { message: 'Logged out.' }, status: :ok
    end

    def log_out_failure
      render json: { message: 'Logged out failure.', errors: response.errors }, status: :unauthorized
    end
  end
end
