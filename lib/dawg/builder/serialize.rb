module Dawg

  class Builder

    def to_binary
      close

      update_offsets

      root_offset = root.info[:binary_offset]
      result = [root_offset].pack('Q')

      root.traverse :backward do |node|
        result += Builder.node_to_binary(node)
      end

      result
    end

    private

    def self.node_to_binary node
      node_sizes_flags_to_binary(node) +
      node.children.map{|letter, node| node_ref_to_binary(letter, node)}.join
    end

    def self.node_ref_to_binary letter, node
      letter.bytes.pack('C*') + varcode(node.info[:binary_offset])
    end

    ## TODO: exchange total_children and children.size ?
    def self.node_sizes_flags_to_binary node
      varcode(
        (node.info[:end_of_word] ? 0x01 : 0x00) +
         node.info[:total_children] * 2
      ) +
      varcode(node.children.size)
    end

    ROOT_NODE_OFFSET_BYTES = 4

    def update_offsets
      offset = ROOT_NODE_OFFSET_BYTES

      root.traverse :backward do |node|
        node.info[:binary_offset] = offset
        offset += Builder.node_to_binary(node).length
      end
    end

    def self.varcode value
      raise RangeError, "Expected non-negative integer, but got #{value}" if value < 0
      return [value].pack('C') if value < 128

      bytes = []
      until value == 0
        bytes << (0x80 | (value & 0x7f))
        value >>= 7
      end
      bytes[-1] &= 0x7f
      bytes.pack('C*')
    end

  end

end
