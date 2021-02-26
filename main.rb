#!/usr/bin/env ruby
# .ruby-version 2.5.3

require 'json'
require 'pp'
require_relative './processor'


def process_events(event_stream, rules)
  begin
    result_event_stream = []
    event_stream.each do |event|
      result_event_stream << Processor.new(rules).process(event)
    end
    print_and_write_file(result_event_stream.compact, true)
  rescue StandardError => e
    puts "Error processiing rules for the event streams: #{e.message}"
  end
end

def print_and_write_file(processed_events, compare_to_expected)

  json_result = JSON.pretty_generate(processed_events)
  File.open("output.json","w") do |f|
    f.write(json_result)
  end

  if compare_to_expected
    e = JSON.parse(File.read('expected_output.json'))

    m = (e == processed_events) ? "✅ matches expected" : "❌ does not match expected"

    puts
    puts "--------------------"

    if e != processed_events
        # use git diff for colorized output
       system("diff expected_output.json output.json")
    end

    puts m
    puts "--------------------"
  end
end


def usage
  puts "processor.rb [rules.json] [event_stream.json]"
end


if __FILE__ == $0
  if ARGV.size > 2
    usage()
    exit(1)
  end

  # default to these files in cwd
  event_stream_file = "event_stream.json"
  rules_file = "rules.json"

  if ARGV.size == 2
    event_stream_file = ARGV[1]
  end

  if ARGV.size == 1
    rules_file = ARGV[0]
  end

  event_stream = JSON.parse(File.read(event_stream_file))
  rules = JSON.parse(File.read(rules_file))

  process_events(event_stream, rules)
end
