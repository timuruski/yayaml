require "psych"

module Yayaml
  class Handler < Psych::Handler
    # State transitions:
    # branch -> (start_map) -> branch (no-op)
    # leaf -> (start_map) -> branch (no-op)
    # leaf -> (start_seq) -> sequence (push index)
    # sequence -> (scalar) -> sequence (incr index)
    # sequence -> (end_seq) -> branch (pop index 2x
    # branch -> (scalar) -> leaf (push key)
    # leaf -> (scalar) -> leaf (pop key, handle value)
    # branch -> (end_map) -> branch (pop key)
    # leaf -> (end_map) -> branch (pop key)

    # For details on Psych events:
    # https://ruby-doc.org/3.2.2/exts/psych/Psych/Handler.html
    # https://github.com/ruby/psych/blob/master/lib/psych/handler.rb

    attr_reader :matcher, :filename

    def initialize(matcher, filename: nil)
      @matcher = matcher
      @filename = filename
    end

    def start_document(*args)
      debug "start_document #{filename}"

      @state = :branch
      @prev = nil
      @keys = []
      @line = 0
      @col = 0
    end

    def start_mapping(*args)
      transition("start_map") do
        case @state
        when :branch, :leaf
          @state = :branch
        else
          panic("start_mapping")
        end
      end
    end

    def end_mapping
      transition("end_map") do
        case @state
        when :branch, :leaf
          @state = :branch
          @keys.pop
        else
          panic("end_mapping")
        end
      end
    end

    def start_sequence(*args)
      transition("start_seq") do
        case @state
        when :leaf, :branch
          @state = :sequence
          @keys.push(0)
        else
          panic("start_sequence")
        end
      end
    end

    # This is only works if sequences aren't nested.
    def end_sequence
      transition("end_seq") do
        case @state
        when :sequence
          @state = :branch
          @keys.pop(2)
        else
          panic("end_sequence")
        end
      end
    end

    def scalar(value, *args)
      transition("scalar") do
        case @state
        when :branch
          @state = :leaf
          @keys.push(value)
        when :sequence
          matcher.on_node(@keys.dup, value, @filename, @line)
          @keys[-1] += 1
        when :leaf
          @state = :branch
          matcher.on_node(@keys.dup, value, @filename, @line)
          @keys.pop
        else
          panic("scalar")
        end
      end
    end

    def event_location(start_line, start_column, end_line, end_column)
      @line = start_line + 1
      @col = start_column + 1
    end

    private def transition(event)
      @prev = @state
      yield
      debug "#@prev -> (#{event})#{@keys} -> #@state"
    end

    private def debug(msg)
      warn msg if Yayaml::DEBUG
    end

    private def panic(event)
      fail "Failed to parse #{event} at #{filename}:#{@line}:#{@col}"
    end
  end
end
