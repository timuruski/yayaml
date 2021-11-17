#!/usr/bin/env ruby

require "psych"
require "pry"

# Handler for detecting scalar values
class YayHandler < Psych::Handler
  # States:
  # a -> start_map -> b
  # b -> scalar -> c (push key)
  # b -> end_map -> b (pop key)
  # c -> scalar -> b (push value, pop key)
  # c -> start_map -> b (push map)
  # c -> end_map -> b (pop key)

  attr_accessor :parser

  def initialize(*args)
    @state = :a
    @prev = nil
    @keys = []
  end

  def start_mapping(*args)
    @prev = @state
    case @state
    when :a
      @state = :b
    when :c
      @state = :b
    else
      fail
    end

    transition("start map")
  end

  def end_mapping
    @prev = @state
    case @state
    when :b, :c
      @state = :b
      @keys.pop
    else
      fail
    end

    transition("end map")
  end

   def scalar(value, *args)
     @prev = @state
     case @state
     when :b
       @state = :c
       @keys << value
     when :c
       @state = :b
       puts "#{@keys.join('.')}:#{parser.mark.line + 1}: #{value}"
       @keys.pop
     else
       fail
     end

     transition("scalar")
   end

   def transition(event)
     # puts "#@prev -> (#{event}) -> #@state"
   end
end

# yaml = File.read("/Users/timuruski/en.yml")
yaml = DATA
handler = YayHandler.new
parser = Psych::Parser.new(handler)
handler.parser = parser
parser.parse(yaml)

__END__
---
en:
  page1:
    button: Hello
  page2:
    button: Goodbye
fr:
  page1:
    button: Bonjour