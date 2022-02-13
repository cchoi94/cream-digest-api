class Api::V1::IntegrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_integration, only: %i[index show update destroy]
  before_action :has_oauth_integration?, only: %i[get_oauth_url set_oauth_tokens]

  def test_qt
    current_user.integrations.find(params[:id]).handle_positions_creation
  end

  def index
    if current_user.present?
      render json: current_user.integrations
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def show
    if @integration.present?
      render json: @integration.handle_positions_creation
    else
      render json: @integration.errors, status: :unprocessable_entity
    end
  end

  def create
    integration = current_user.integrations.new(integration_params)
    encrypted_integration = encrypt_integration(integration, integration_params)
    if encrypted_integration.save!
      encrypted_integration.handle_positions_creation
    else
      render json: encrypted_integration.errors, status: :unprocessable_entity
    end
  end

  def update
    @integration.assign_attributes(integration_params)
    encrypted_integration = encrypt_integration(@integration, integration_params)
    if encrypted_integration.save!
      render json: encrypted_integration
    else
      render json: encrypted_integration.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @integration.destory
      render json: {message: "user has been deleted"}
    else
      render json: @integration.errors, status: :unprocessable_entity
    end
  end

  def get_oauth_url
    case params[:name]
    when "questrade"
      render json: Questrade.oauth_url
    else
      render json: {message: "#{params[:name]} is not an oauth"}
    end
  end

  private

  def set_integration
    @integration = current_user.integrations.find(params[:id])
  end

  def integration_params
    params.require(:integration).permit(:name, :user_id, :access_token, :refresh_token, :oauth_code, :client_id, :secret_key)
  end

  def encrypt_integration(integration, integration_params)
    if integration_params[:access_token].present?
      integration.access_token = integration.encrypt_string(integration.access_token)
    end
    if integration_params[:refresh_token].present?
      integration.refresh_token = integration.encrypt_string(integration.refresh_token)
    end
    if integration_params[:client_id].present?
      integration.client_id = integration.encrypt_string(integration.client_id)
    end
    if integration_params[:secret_key].present?
      integration.secret_key = integration.encrypt_string(integration.secret_key)
    end
    integration
  end

  def has_oauth_integration?
    return render json: {message: "Integration name not specified"} unless integration_params[:name].present?
  end
end
