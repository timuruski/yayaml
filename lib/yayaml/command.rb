require "optparse"

module Yayaml
  class Command
    def initialize(args = ARGV)
      @ignore_case = true
      @match_path = false

      parser = OptionParser.new do |parser|
        parser.on("-d", "--debug") { $DEBUG = true }
        parser.on("-s", "--case-sensitive") { |value| @ignore_case = !value }
        parser.on("-p", "--match-path") { |value| @match_path = value }
      end

      parser.banner = "Usage yay [options] \"<search pattern>\" <inputs>"
      if args.empty?
        abort parser.help
      else
        parser.parse!
      end

      @search_pattern = args.shift
      @paths = args.flat_map { |filename| File.directory?(filename) ? Dir.glob("#{filename}/**/*.yml") : filename }
      @paths.delete("--")
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
      matcher = Matcher.new(@search_pattern, match_path: @match_path, ignore_case: @ignore_case)
      handler = Handler.new(matcher, filename: filename)
      Psych::Parser.new(handler).parse(input)
    rescue Psych::SyntaxError => e
      warn "Failed to parse YAML #{e.file}:#{e.line}:#{e.offset}"
    end
  end
end
