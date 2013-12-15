require 'spec_helper'
require 'dawg'

describe Dawg::Builder do

  it "should raise an error if words are fed in non-alphabetical order" do
    b = Dawg::Builder.new
    b.add_word 'dog'
    lambda{b.add_word 'cat'}.should raise_error(Dawg::InvalidOrderError)
  end

  it "should raise an error when adding to closed builder" do
    b = Dawg::Builder.new
    b.add_word 'cat'
    b.close
    lambda{b.add_word 'dog'}.should raise_error(Dawg::BuilderClosedError)
  end

  it "should build a simple tree" do
    b = Dawg::Builder.new
    b.add_word 'cat'
    b.add_word 'dog'
    b.close

    b.root.children.length.should == 2
    b.root['c'].children.length.should == 1
    b.root['c']['a'].children.length.should == 1
    b.root['c']['a']['t'].children.length.should == 0
    b.root['c']['a']['t'].info[:end_of_word].should == true
    b.root['d'].children.length.should == 1
    b.root['d']['o'].children.length.should == 1
    b.root['d']['o']['g'].children.length.should == 0
    b.root['d']['o']['g'].info[:end_of_word].should == true
  end

  it "should reuse common prefixes" do
    b = Dawg::Builder.new
    b.add_word 'replay'
    b.add_word 'rework'
    b.close
    b.root.children.length.should == 1
    b.root['r'].children.length.should == 1
    b.root['r']['e'].children.length.should == 2
    b.root['r']['e']['w'].children.length.should == 1
    b.root['r']['e']['p'].children.length.should == 1
  end

  it "should reuse common suffixes" do
    b = Dawg::Builder.new
    b.add_word 'overwork'
    b.add_word 'rework'
    b.close
    b.root.children.length.should == 2
    over_suffix = b.root['o']['v']['e']['r']
    re_suffix = b.root['r']['e']

    over_suffix.should equal(re_suffix)
  end

  it "should reuse both prefixes and suffixes" do
    b = Dawg::Builder.new
    b.add_word 'overplay'
    b.add_word 'overwork'
    b.add_word 'replay'
    b.add_word 'rework'
    b.close
    b.root.children.length.should == 2

    over_suffix = b.root['o']['v']['e']['r']
    re_suffix = b.root['r']['e']
    over_suffix.children.length.should == 2 # play and work
    over_suffix.should equal(re_suffix)
  end

end
