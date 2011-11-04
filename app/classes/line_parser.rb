class LineParser
  def self.parse(line)
    line_matches = line.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^\+#]([[:print:]][^\+#])*))?( +?(\+(?<quantity>\d+)))?( +?#(?<cat1>[[:print:]][^#]*))?$/)
    return matches_to_hash(line_matches)
  end
  def self.matches_to_hash(matches)
    hash = {}
    keys = [:name, :price, :description_text, :quantity, :cat1]
    keys.each do |key|
      if key == :price
        hash[key] = matches[key].to_f
      elsif key == :quantity
        if matches[key].nil?
          hash[key] = 1
        else
          hash[key] = matches[key].to_i
        end
      else
        hash[key] = matches[key]
      end
    end
    hash
  end
end