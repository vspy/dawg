module Dawg

  class Builder

    def to_binary
      close

      update_offsets :binary_offset
    end

    private

    BINARY_TOTAL_CHILDREN_BYTES = 4
    BINARY_REF_BYTES = 4

    def update_offsets key, total_children_size, ref_size, node=root, offset = 0
      node.info[:binary_offset] = offset

      free = offset + 
             total_children_size +
             node.children.values.length * ref_size +
             node.children.keys.inject(0) do |r, v| end

      node.children.values.inject(free) do |r, v|
        update_binary_offsets v, r
      end

    end

  end

end
