class CurrencySwitcher
  def initialize(args)
    @description = args
  end
  def get_currency
    Currency::USD
  end
end