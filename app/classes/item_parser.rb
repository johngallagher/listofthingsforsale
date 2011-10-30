class ItemParser
  def self.parse(description)
    Rails.logger.debug "About to match #{description}"
    # description.match(/([[:print:]]+) \$(\d+\.*\d*)([[:print:]][^\+#]*)?(\+(\d+))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?( #([[:print:]][^#]*))?$/)
    # description.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<descr> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?( #(?<cat2>[[:print:]][^#]*))?( #(?<cat3>[[:print:]][^#]*))?( #(?<cat4>[[:print:]][^#]*))?( #(?<cat5>[[:print:]][^#]*))?$/)
    description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<description_text> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?$/)
    # description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<description_text> [[:print:]][^\+#]*)?(?<quantity>\+(\d+))?(?<cat1> #([[:print:]][^#]*))?( #(?<cat2>[[:print:]][^#]*))?( #(?<cat3>[[:print:]][^#]*))?( #(?<cat4>[[:print:]][^#]*))?( #(?<cat5>[[:print:]][^#]*))$/)
    # description.match(/([[:print:]]+) \$(\d+\.*\d*)( [[:print:]][^\+]*)?(\+(\d+))?/)
  end
  
end