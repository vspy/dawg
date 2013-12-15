require 'spec_helper'
require 'dawg'

describe Dawg::Builder do

  it "should serialize node flags" do
    n1 = Dawg::Builder::Node.new :end_of_word => false, :total_children => 3
    ('a'..'f').each do |letter|
      n1.children[letter] = Dawg::Builder::Node.new
    end

    n2 = Dawg::Builder::Node.new :end_of_word => true, :total_children => 7
    ('a'..'c').each do |letter|
      n2.children[letter] = Dawg::Builder::Node.new
    end

    Dawg::Builder.node_sizes_flags(n1).should == [6,6].pack('CC')
    Dawg::Builder.node_sizes_flags(n2).should == [15,3].pack('CC')
  end

end
