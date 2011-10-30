class ItemParser
  def self.parse(description)
    Rails.logger.debug "About to match #{description}"
    # description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)(?<description_text> ([^\+#][[:print:]])*)?(?<quantity>\+(\d+))?( #(?<cat1>[[:print:]][^#]*))?$/)
    description.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^\+#]([[:print:]][^\+#])*))?( +?(\+(?<quantity>\d+)))?( +?#(?<cat1>[[:print:]][^#]*))?$/)
  end
end