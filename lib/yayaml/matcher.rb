module Yayaml
  class Matcher
    # TODO: Make colored output optional
    BOLD_RED = "\e[1m\e[38;5;1m"
    BOLD = "\e[1m"
    RED = "\e[38;5;1m"
    RESET = "\e[0m"

    # TODO: Handle glob style patterns
    # TODO: Handle ignore-case option, make it enabled by default
    def initialize(pattern, list_keys: false, match_path: false, ignore_case: true)
      flags = !!ignore_case ? Regexp::IGNORECASE : 0
      @pattern = Regexp.compile(pattern, flags)
      @match_path = match_path
      @ignore_case = ignore_case
      @list_keys = list_keys
    end

    def on_node(keys, value, filename, line)
      path = keys.join(".")

      if @list_keys
        list_key(path, value, filename, line)
      elsif @match_path
        match_path(path, value, filename, line)
      else
        match_value(path, value, filename, line)
      end
    end

    private def list_key(path, value, filename, line)
      puts "#{filename}:#{line} #{path}"
      # puts path
    end

    private def match_path(path, value, filename, line)
      if (match = path.match(@pattern))
        if $stdout.tty?
          path_matched = path.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
          puts "#{filename}:#{line} #{path_matched}: #{value}"
        else
          puts "#{filename}:#{line} #{path}: #{value}"
        end
      end
    end

    private def match_value(path, value, filename, line)
      if (match = value.match(@pattern))
        if $stdout.tty?
          value_matched = value.sub(@pattern, "#{BOLD_RED}#{match}#{RESET}")
          puts "#{filename}:#{line} #{path}: #{value_matched}"
        else
          puts "#{filename}:#{line} #{path}: #{value}"
        end
      end
    end
  end
end
