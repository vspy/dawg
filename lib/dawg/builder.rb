require 'dawg/builder/node'
require 'dawg/builder/add_word'
require 'dawg/builder/close'

module Dawg

  class Builder
    attr_reader :root

    def initialize
      @last_word = nil
      @registry = {}
      @closed = false

      @root = Node.new
    end

  end

end
