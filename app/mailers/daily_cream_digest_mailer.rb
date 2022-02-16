class DailyCreamDigestMailer < ApplicationMailer
  def new_cream_digest
    @user = params[:user]
    @total_equity = get_total_equity
    @open_pnl = get_open_pnl
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

  def get_open_pnl
    yesterdays_open_pnl = @user.positions.sum(:yesterday_start_equity)
    todays_open_pnl = @user.positions.sum("price * amount")
    open_pnl_difference = todays_open_pnl - yesterdays_open_pnl
    ((open_pnl_difference) * (open_pnl_difference < 0 ? -1 : 1)).round(2)
  end
end
