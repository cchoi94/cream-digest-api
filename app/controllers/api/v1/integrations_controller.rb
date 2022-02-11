module Api
  module V1
    class IntegrationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_integration, only: %i[show update destroy]

      def index
        if current_user.present?
          render json: current_user.integrations
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      def show
        if @integration.present?
          render json: @integration
        else
          render json: @integration.errors, status: :unprocessable_entity
        end
      end

      def create
        integration = current_user.integrations.new(integration_params)
        encrypted_integration = encrypt_integration_tokens(integration, integration_params)
        if encrypted_integration.save!
          render json: encrypted_integration
        else
          render json: encrypted_integration.errors, status: :unprocessable_entity
        end
      end

      def update
        @integration.assign_attributes(integration_params)
        encrypted_integration = encrypt_integration_tokens(@integration, integration_params)
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

      private

      def set_integration
        @integration = current_user.integrations.find(params[:id])
      end

      def integration_params
        params.require(:integration).permit(:name, :user_id, :access_token, :refresh_token)
      end

      def encrypt_integration_tokens (integration, integration_params)
        if integration_params[:access_token].present?
          integration.access_token = integration.encrypt_token(integration.access_token)
        end
        if integration_params[:refresh_token].present?
          integration.refresh_token = integration.encrypt_token(integration.refresh_token)
        end
        integration
      end
    end
  end
end
