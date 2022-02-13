class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[forgot_password check_reset_password_token reset_password]

  def show
    if current_user.present?
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.destory
      render json: {message: "user has been deleted"}
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def update_user_password
    if current_user.valid_password?(params[:old_password]) == false
      return render json: {code: "incorrectCurrentPassword"}, status: :unprocessable_entity
    end

    if current_user.reset_password(params[:new_password], params[:confirm_password])
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:reset_password_token])
    if user.reset_password(params[:new_password], params[:confirm_password])
      render json: {message: "Password has been successfully resetted"}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def check_reset_password_token
    token = params[:reset_password_token]
    user = User.find_by(reset_password_token: token)
    hours_since_reset_password_request = ((Time.now.utc - user.reset_password_sent_at) / 1.hour).round

    if user.present?
      if user.reset_password_token != token
        return render json: {
          message: "This link is invalid, please request another forgot password and use the new link to reset password"
        }, status: :unprocessable_entity
      end
      if user.reset_password_token == token && hours_since_reset_password_request > 6
        return render json: {
          message: "This link has expired, please request another forgot password and use the new link to reset password"
        }, status: :unprocessable_entity
      end
      render json: {
        message: "Token is valid and within expiration time"
      }
    else
      render json: {
        message: "This link is invalid", status: :unprocessable_entity
      }
    end
  end

  def forgot_password
    @user = User.find_by(email: params[:email])
    _raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc
    if @user.save!
      UserMailer.with(
        user: @user,
        reset_password_token: enc
      ).forgot_password.deliver_now
      render json: {
        message: "forgot password email has been successfully sent"
      }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone,
      :send_daily_email, :onboarding, :old_password,
      :new_password, :confirm_password, :reset_password_token)
  end
end
