require "psych"

module Yay
  class Handler < Psych::Handler
    # State transitions:
    # branch -> start_map -> branch (no-op)
    # leaf -> start_map -> branch (no-op)
    # branch -> scalar -> leaf (push key)
    # leaf -> scalar -> leaf (pop key, handle value)
    # branch -> end_map -> branch (pop key)
    # leaf -> end_map -> branch (pop key)

    attr_reader :matcher, :filename

    def initialize(matcher, filename: nil)
      @matcher = matcher
      @filename = filename
    end

    def start_document(*args)
      debug "--> Start document #{filename}"

      @state = :branch
      @prev = nil
      @keys = []
      @line = 0
      @col = 0
    end

    def start_mapping(*args)
      transition("start map") do
        case @state
        when :branch, :leaf
          @state = :branch
        else
          panic("start_mapping")
        end
      end
    end

    def end_mapping
      transition("end map") do
        case @state
        when :branch, :leaf
          @state = :branch
          @keys.pop
        else
          panic("end_mapping")
        end
      end
    end

    def scalar(value, *args)
      transition("scalar") do
        case @state
        when :branch
          @state = :leaf
          @keys.push(value)
        when :leaf
          @state = :branch
          matcher.on_node(@keys.dup, value)
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
      # debug "#@prev -> (#{event}) -> #@state"
    end

    private def debug(msg)
      warn msg if @debug
    end

    private def panic(event)
      fail "Failed to parse #{event} at #{filename}:#{@line}:#{@col}"
    end
  end
end
