class Api::V1::PositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_position, only: %i[show]

  def index
    if current_user.present?
      render json: current_user.positions
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def show
    if @position.present?
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  private

  def set_position
    @position = current_user.positions.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:name, :type, :amount, :integration_id, :account, :price, :open_pnl)
  end
end
