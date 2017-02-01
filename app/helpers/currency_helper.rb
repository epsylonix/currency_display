module CurrencyHelper
  def localize_curr curr
    number_to_currency(curr, locale: locale, unit: '')
  end

  def update_failed curr
    curr.update_failed and !curr.forced
  end
end
