require "optparse"

module Yayaml
  class Command
    def self.build(args)
      opts = {
        case_sensitive: false,
        match_path: false
      }

      parser = OptionParser.new do |parser|
        parser.on("-d", "--debug") { $DEBUG = true }
        parser.on("-l", "--list_keys") { opts[:list_keys] = true }
        parser.on("-s", "--case-sensitive") { |value| opts[:case_sensitive] = value }
        parser.on("--flatten") { |value| opts[:search_pattern] = "." }
        parser.on("-p", "--match-path") { |value| opts[:match_path] = value }
      end

      parser.banner = "Usage yay [options] \"<search pattern>\" <inputs>"
      if args.empty?
        abort parser.help
      else
        parser.parse!
      end

      opts[:search_pattern] ||= args.shift.to_s
      opts[:paths] = args.flat_map { |filename| File.directory?(filename) ? Dir.glob(File.join(filename, "**/*.yml")) : filename }
      opts[:paths].delete("--")

      new(**opts)
    end

    attr_reader :case_sensitive, :match_path
    attr_reader :search_pattern, :paths

    def initialize(case_sensitive: false, list_keys: false, match_path: false, paths: [], search_pattern: "")
      @case_sensitive = false
      @list_keys = list_keys
      @match_path = false
      @paths = paths.to_a
      @search_pattern = search_pattern
    end

    # TODO: Use abort if all YAML paths fail to parse.
    def run
      if @paths.empty?
        warn "Reading from STDIN..." if STDIN.tty?
        parse_yaml(STDIN, "STDIN")
      else
        @paths.each do |path|
          File.open(path) do |file|
            parse_yaml(file, file.path)
          end
        end
      end
    end

    # TODO: Move this out of the Command core
    private def parse_yaml(input, filename)
      matcher = Matcher.new(@search_pattern, list_keys: @list_keys, match_path: @match_path, ignore_case: !@case_sensitive)
      handler = Handler.new(matcher, filename: filename)
      Psych::Parser.new(handler).parse(input)
    rescue Psych::SyntaxError => e
      warn "Failed to parse YAML #{e.file}:#{e.line}:#{e.offset}"
    end
  end
end
