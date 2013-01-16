# encoding: UTF-8
class DescriptionFilterer
  def initialize(args)
    @description = args
    @currency = CurrencySwitcher.new(@description).get_currency
    @unwanted_currencies = Currency::Supported - [@currency]
  end
  def replace_unwanted_currencies
    @unwanted_currencies.each do |unwanted_currency|
      unwanted_currency_escaped = Currency::EscapedSymbol[unwanted_currency]
      @description.gsub!(/#{unwanted_currency_escaped}(\d+\.*\d*)/, "#{Currency::Symbol[@currency]}\\1") unless @description.nil?
    end
    @description
  end
end