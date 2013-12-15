module Dawg

  class Builder

    def to_binary io
      close

      update_offsets

      # root node offset, 64 bits unsigned
      root_offset = root[:binary_offset]
      io.write [root_offset].pack('Q')

      # write nodes
      root.traverse :backward do |node|
        io.write node_to_binary(node)
      end
    end

    private

    def self.node_to_binary node
      node_sizes_flags(node) +
      node.children.map{|letter, node|
        [letter].pack('U') +
        varcode(node.info[:binary_offset])
      }.join
    end

    ## TODO: exchange total_children and children.size ?
    def self.node_sizes_flags node
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
        offset += node_to_binary(node).length
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
