# encoding: UTF-8
class CurrencySwitcher
  def initialize(args)
    @description = args
    @supported_currencies = [Currency::USD, Currency::GBP]
  end
  def get_currency
    pound_matches = @description.match(/£\d+/)
    dollar_matches = @description.match(/\$\d+/)
    pound_matches ||= ""
    dollar_matches ||= ""
    if pound_matches.length > dollar_matches.length
      Currency::GBP
    else
      Currency::USD
    end
  end
end