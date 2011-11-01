class ItemMatcher
  def initialize(args)
    @items = args[:items]
    @criteria = args[:criteria]
  end
  def match
    @items[0]
  end
end