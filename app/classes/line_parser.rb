class LineParser
  def self.parse(line)
    line.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^\+#]([[:print:]][^\+#])*))?( +?(\+(?<quantity>\d+)))?( +?#(?<cat1>[[:print:]][^#]*))?$/)
  end
end