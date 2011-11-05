class CategoryNameSanitizer
  def initialize(name)
    @name = name
  end
  def sanitize
    @name.strip!
    if @name.match(/^-?[_a-zA-Z]+[_a-zA-Z0-9-]*$/).nil?
      @name = clean
    end
    @name
  end
  
  def clean
    char_index = 1
    cleaned_name = ""
    @name.each_byte do |char_code|
      cleaned_char = cleaned_char(char_code.chr, char_index)
      cleaned_name << cleaned_char
      char_index++
    end
    cleaned_name
  end
  
  def cleaned_char(this_char, char_index)
    if char_index == 1
      this_char = "" if this_char.match(/^[a-zA-Z]$/).nil?
    else
      this_char = "-" if this_char == " "
      this_char = "" if this_char.match(/^[_a-zA-Z0-9-]$/).nil?
    end
    this_char
  end
end