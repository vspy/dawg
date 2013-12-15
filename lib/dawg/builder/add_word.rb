module Dawg

  class Builder

    def add_word word
      return if word.empty?
      raise BuilderClosedError.new('Builder is closed, no words can be added.') if @closed
      raise InvalidOrderError.new('Words must be added in alphabetical order') if @last_word && @last_word > word

      cp, last_state = common_prefix word

      current_suffix = word[cp.length..(word.length-1)]

      replace_or_register last_state if last_state.has_children?
      add_suffix(last_state, current_suffix)

      @last_word = word
    end

    private

    def common_prefix word
      current_state = @root
      prefix = ''
      idx = 0
      
      while idx<word.length &&
            (letter = word[idx]) &&
            (next_state = current_state[letter])
        prefix << letter
        current_state = next_state
        idx = idx + 1
      end

      [prefix, current_state]
    end

    def replace_or_register state
      child = state.last_child
      replace_or_register(child) if child.has_children?

      registry_eq=@registry[child]
      if registry_eq
        state.last_child = registry_eq
      else
        @registry[child]=child
      end
    end

    def add_suffix state, suffix
      current_state = state
      idx = 0

      while idx<suffix.length
        letter = suffix[idx]

        info = {}
        eow = (idx == (suffix.length-1))
        info.merge! :end_of_word => true if eow

        node = Node.new info

        current_state[letter] = node  
        current_state = node
        idx = idx + 1
      end
    end

  end

end
