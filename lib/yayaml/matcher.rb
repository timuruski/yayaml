module Yayaml
  class Matcher
    BOLD_RED = "\e[1m\e[38;5;1m"
    RESET = "\e[0m"

    attr_reader :nodes

    def initialize(pattern, match_path: false, ignore_case: false)
      @pattern = Regexp.compile(pattern)
      @match_path = match_path
      @ignore_case = ignore_case

      @nodes = []
    end

    def on_node(keys, value)
      @nodes << [keys, value]

      path = keys.join(".")

      if @match_path
        if (match = path.match(@pattern))
          path_matched = path.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
          # puts "#{path_matched}:#{@line}: #{value}"
          puts "#{@filename}:#{@line} #{path_matched}: #{value}"
        end
      else
        if (match = value.match(@pattern))
          value_matched = value.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
          # puts "#{path}:#{@line}: #{value_matched}"
          puts "#{@filename}:#{@line} #{path}: #{value_matched}"
        end
      end
    end

    private def match_value(keys, value)
      if (match = value.match(@pattern))
        value_matched = value.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
        # puts "#{path}:#{@line}: #{value_matched}"
        puts "#{@filename}:#{@line} #{path}: #{value_matched}"
      end
    end

    private def match_path(keys, value)
      if (match = path.match(@pattern))
        path_matched = path.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
        # puts "#{path_matched}:#{@line}: #{value}"
        puts "#{@filename}:#{@line} #{path_matched}: #{value}"
      end
    end
  end
end
