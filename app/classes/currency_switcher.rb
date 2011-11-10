# encoding: UTF-8
class CurrencySwitcher
  def initialize(args)
    @description = args
    @supported_currencies = [Currency::USD, Currency::GBP]
  end
  def get_currency
    pound_matches = @description.scan(/(?<name>[[:print:]]+) £(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/m)
    dollar_matches = @description.scan(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/m)
    pound_matches ||= ""
    dollar_matches ||= ""
    if pound_matches.count > dollar_matches.count
      Currency::GBP
    else
      Currency::USD
    end
  end
end


# /(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/