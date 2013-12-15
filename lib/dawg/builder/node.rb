module Dawg

  class Builder

    class Node
      attr_accessor :info

      def initialize info = {}
        @info = info
        @children = {}
      end

      def []= letter, child
        @children[letter] = child
        @last_letter = letter
        @last_child = child
      end

      def [] letter
        @children[letter]
      end

      def children
        @children
      end

      def has_children?
        @children.length > 0
      end

      def last_child= new_child
        @children[@last_letter] = new_child
      end

      def last_child
        @last_child
      end

      def hash
        @info.hash + @children.hash
      end

      def traverse type = :forward, &block
        if type == :forward
          block.call(self)
        end

        @children.each do |letter, child|
          child.traverse type, &block
        end

        if type != :forward
          block.call(self)
        end
      end

      def eql?(other)
        other && other.is_a?(Node) &&
          other.info == info &&
          other.children == children
      end

    end

  end

end
