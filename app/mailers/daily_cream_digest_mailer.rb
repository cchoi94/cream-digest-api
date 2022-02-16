class DailyCreamDigestMailer < ApplicationMailer
  def new_cream_digest
    @user = params[:user]
    @total_equity = get_total_equity
    @day_pnl = get_day_pnl
    @stocks = @user.positions.where(type: "Stock")
    @cryptocurrencies = @user.positions.where(type: "Cryptocurrency")

    mail(
      subject: "💸 Your Morning Cream",
      to: @user.email,
      from: "Cream Digest",
      track_opens: "true",
      message_stream: "outbound"
    )
  end

  private

  def get_total_equity
    (@user.balances.where(currency: "USD").sum(:total_equity) * 1).round(2)
  end

  def get_day_pnl
    yesterdays_day_pnl = @user.positions.sum(:yesterday_start_equity)
    todays_day_pnl = @user.positions.sum("price * amount")
    day_pnl_difference = todays_day_pnl - yesterdays_day_pnl
    (day_pnl_difference * 1).round(2)
  end
end
