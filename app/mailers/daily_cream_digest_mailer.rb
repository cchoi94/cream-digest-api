class DailyCreamDigestMailer < ApplicationMailer
  def new_cream_digest
    @user = params[:user]
    @total_equity = get_total_equity
    @open_pnl = get_open_pl
    @stocks = @user.positions.where(type: "Stock")
    @cryptocurrencies = @user.positions.where(type: "CryptoCurrency")

    mail(
      subject: "Your Morning Cream",
      to: @user.email,
      from: "cream@creamdigest.com",
      track_opens: "true",
      message_stream: "outbound"
    )
  end

  private

  def get_total_equity
    (@user.balances.where(currency: "USD").sum(:total_equity) * 1).round(2)
  end

  def get_open_pl
    (@user.positions.sum(:open_pnl) * 1).round(2)
  end
end
