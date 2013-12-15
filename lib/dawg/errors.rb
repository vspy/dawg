module Dawg

  class DawgError < Exception; end

  class InvalidOrderError < DawgError; end

  class BuilderClosedError < DawgError; end

end
