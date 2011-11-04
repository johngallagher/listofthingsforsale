class LineParser
  def self.parse(line)
    line_matches = line.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^\+#]([[:print:]][^\+#])*))?( +?(\+(?<quantity>\d+)))?( +?#(?<cat1>[[:print:]][^#]*))?$/)
    matches_to_hash(line_matches) unless line_matches.nil?
  end
  def self.matches_to_hash(matches)
    {
      :name             => matches[:name]
      :price            => matches[:price].to_f
      :description_text => matches[:description_text]
      :quantity         => (matches[:quantity] || 1).to_i
      :cat1             => matches[:cat1]
    }
  end
end