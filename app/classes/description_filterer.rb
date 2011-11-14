# encoding: UTF-8
class DescriptionFilterer
  def initialize(args)
    @description = args
  end
  def replace_unwanted_currencies
    @description.sub(/£(\d+\.*\d*)/, "\$\\1")
  end
end