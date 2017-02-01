class CurrenciesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "currencies"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
