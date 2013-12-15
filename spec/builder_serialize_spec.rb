# encoding: utf-8

require 'spec_helper'
require 'dawg'

describe Dawg::Builder do

  it "should varcode offsets properly" do
    Dawg::Builder.varcode(42).should == [42].pack('C')
    Dawg::Builder.varcode(128).should == [0x80,0x01].pack('CC')
    Dawg::Builder.varcode(130).should == [0x82,0x01].pack('CC')
  end

  it "should serialize node flags" do
    n1 = Dawg::Builder::Node.new :end_of_word => false, :total_children => 3
    ('a'..'f').each do |letter|
      n1.children[letter] = Dawg::Builder::Node.new
    end

    n2 = Dawg::Builder::Node.new :end_of_word => true, :total_children => 7
    ('a'..'c').each do |letter|
      n2.children[letter] = Dawg::Builder::Node.new
    end

    Dawg::Builder.node_sizes_flags_to_binary(n1).should == [6,6].pack('CC')
    Dawg::Builder.node_sizes_flags_to_binary(n2).should == [15,3].pack('CC')
  end

  it "should serialize node references" do
    n = Dawg::Builder::Node.new :binary_offset => 130
    Dawg::Builder.node_ref_to_binary('Я', n).should == [0xD0, 0xAF, 0x82, 0x01].pack('C*')
  end

  it "should serialize simple tree" do
    b = Dawg::Builder.new
    b.add_word 'cat'
    b.add_word 'dog'
    b.to_binary.unpack('C*').should == [0]
  end

end
