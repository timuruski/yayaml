require "optparse"

OptionParser.new do |parser|
  parser.on("-a") { |v| puts "a: #{v}" }
  parser.on("-b") { |v| puts "b: #{v}" }
end.parse!

p ARGV
