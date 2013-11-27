module Dawg

  class DawgException < Exception; end

  class InvalidOrderException < DawgException; end

  class BuilderClosedException < DawgException; end

end
