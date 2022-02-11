# frozen_string_literal: true

module Api
  module V1
    class IntegrationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_client, only: %i[show update destroy]

      def index
        if current_user.present?
          render json: current_user.integrations
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

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
          render json: { message: 'user has been deleted' }
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      private

      def set_integration
        @integration = current_user.organizations.find(params[:id])
      end
      
      def integration_params
        params.require(:integration).permit(:name, :user_id, :access_token, :refresh_token)
      end

    end
  end
end
