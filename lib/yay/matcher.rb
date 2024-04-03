module Yay
  class Matcher
    attr_reader :nodes

    def initialize(pattern, match_path: false, ignore_case: false)
      @pattern = pattern
      @match_path = match_path
      @ignore_case = ignore_case

      @nodes = []
    end

    def on_node(keys, value)
      @nodes << [keys, value]
    end
  end
end
