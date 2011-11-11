# encoding: UTF-8
class CurrencySwitcher
  def initialize(args)
    @description = args ? args : ""
    @highest_matches = 0
    @winning_currency = Currency::Supported.first
  end
  
  def get_currency
    Currency::Supported.each do |this_currency|
      update_winning_currency(:currency => this_currency, :matches => currency_matches(this_currency))
    end
    @winning_currency
  end
  
  def currency_matches(this_currency)
    escaped_currency_symbol = Currency::EscapedSymbol[this_currency]
    this_currency_matches = @description.scan(/(?<name>[[:print:]]+) #{escaped_currency_symbol}(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/m)
    this_currency_matches ||= []
  end
  
  def update_winning_currency(args)
    if args[:matches].count > @highest_matches
      @highest_matches = args[:matches].count
      @winning_currency = args[:currency]
    end
  end
end