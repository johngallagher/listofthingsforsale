# encoding: UTF-8
class CurrencySwitcher
  def initialize(args)
    @description = args
  end
  def get_currency
    winning_currency = Currency::Supported.first
    highest_matches = 0
    Currency::Supported.each do |this_currency|
      escaped_currency_symbol = Currency::EscapedSymbol[this_currency]
      this_currency_matches = @description.scan(/(?<name>[[:print:]]+) #{escaped_currency_symbol}(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/m)
      this_currency_matches ||= []
      if this_currency_matches.count > highest_matches
        highest_matches = this_currency_matches.count 
        winning_currency = this_currency
      end
    end
    winning_currency
  end
end