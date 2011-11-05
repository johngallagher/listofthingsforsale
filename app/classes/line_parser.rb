class LineParser
  def self.parse(line)
    line_matches = line.chomp.match(/(?<name>[[:print:]]+) \$(?<price>\d+\.*\d*)( +?(?<description_text>[^#\+][[:print:]]*?))?( +?(\+(?<quantity>\d+)))?( +?#(?<category_1>[[:print:]][^#]*))?( +?#(?<category_2>[[:print:]][^#]*))?( +?#(?<category_3>[[:print:]][^#]*))?( +?#(?<category_4>[[:print:]][^#]*))?( +?#(?<category_5>[[:print:]][^#]*))?( +?#(?<category_6>[[:print:]][^#]*))?$/)
    matches_to_hash(line_matches) unless line_matches.nil?
  end
  def self.matches_to_hash(matches)
    categories = [matches[:category_1], matches[:category_2], matches[:category_3], matches[:category_4], matches[:category_5], matches[:category_6]].select{ |c| c.present? }
    {
      :name             => matches[:name],
      :price            => matches[:price].to_f,
      :description_text => matches[:description_text],
      :quantity         => (matches[:quantity] || 1).to_i,
      :categories       => categories
    }
  end
end