#
# utilities
#
module Subconv
  module Util
    def self.panic(message)
      STDERR.puts message
      exit(1)
    end
  end
end
