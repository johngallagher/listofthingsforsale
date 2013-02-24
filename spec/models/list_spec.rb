require 'spec_helper'

describe List do
  let(:list) { List.new }

  it { should respond_to :products_text }
end
