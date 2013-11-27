module Dawg

  class Builder

    def close
      @closed ||= begin
        replace_or_register(@root)
        update_children_count
        true
      end
    end

  private

    def update_children_count node = root
      node.info[:total_children] = node.children.values.map{|n| update_children_count n}.inject(0, &:+)
      node.info[:total_children]
    end

  end

end
