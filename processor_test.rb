require "test/unit"
require_relative './processor'

class ProcessorTest < Test::Unit::TestCase
  def setup
  end

  def test_regex_match
    rule_condition = { "any" => [{ "operator" => "matchesRegex", "left" => "$page_host", "right" => ".*\\.gusto\\.com$" }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 1,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_less_than
    rule_condition = { "any" => [{ "operator" => "lessThan", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 1,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results

    rule_condition = { "any" => [{ "operator" => "lessThanEqual", "left" => "$ui_events.n_mouse_move", "right" => 1 }] }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_less_than_equal
    rule_condition = { "any" => [{ "operator" => "lessThanEqual", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 1,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results

    rule_condition = { "any" => [{ "operator" => "lessThanEqual", "left" => "$ui_events.n_mouse_move", "right" => 1 }] }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_equal_to
    rule_condition = { "any" => [{ "operator" => "EqualTo", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 2,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_not_equal_to
    rule_condition = { "any" => [{ "operator" => "NotEqualTo", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 3,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_greater_than
    rule_condition = { "any" => [{ "operator" => "GreaterThan", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 3,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_greater_than_equal
    rule_condition = { "any" => [{ "operator" => "GreaterThanEqual", "left" => "$ui_events.n_mouse_move", "right" => 2 }] }
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 3,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results

    rule_condition = { "any" => [{ "operator" => "GreaterThanEqual", "left" => "$ui_events.n_mouse_move", "right" => 3 }] }
    results = Processor.new.build_expression(rule_condition, event)
    assert_true results
  end

  def test_drop_event
    rule_actions = [{ "action" => "dropEvent" }]
    event = {
        "begin_ts" => "2020-09-16 15:00:54.485",
        "end_ts" => "2020-09-16 15:00:58.338",
        "fin_extension_version" => "1.05",
        "id" => 1002,
        "is_in_browser" => true,
        "page_host" => "app.gusto.com",
        "page_title" => "Home - Gusto",
        "page_url" => "https://app.gusto.com/home",
        "ui_events" => {
            "n_keypress" => 0,
            "n_mouse_click" => 0,
            "n_mouse_move" => 3,
            "n_mouse_scroll" => 0
        },
        "user_id" => 56182
    }
    results = Processor.new.run_actions(rule_actions, event)
    assert_nil results
  end

  def test_regex_replace
    rule_actions = [{ "action" => "regexReplace", "keyPath" => "$page_title", "pattern" => "(- Ticket \\d+)", "replacement" => "---" }]
    event = {
        "begin_ts" => "2020-09-16 15:00:58.16",
        "end_ts" => "2020-09-16 15:01:01.456",
        "fin_extension_version" => "1.05",
        "id" => 1003,
        "is_in_browser" => true,
        "page_host" => "fin.zendesk.com",
        "page_title" => "Zendesk (- Ticket 1234)",
        "page_url" => "https://fin.zendesk.com/ticket/1234",
        "ui_events" => {
            "n_keypress" => 62,
            "n_mouse_click" => 0,
            "n_mouse_move" => 10,
            "n_mouse_scroll" => 1
        },
        "user_id" => 56183
    }
    Processor.new.run_actions(rule_actions, event)
    assert_true event['page_title'].include?(rule_actions.first['replacement'])
  end

  def test_array_append
    rule_actions = [{ "action" => "arrayAppend", "keyPath" => "$extra.array", "pattern" => nil, "replacement" => nil, "value" => 'value' }]
    event = {
        "begin_ts" => "2020-09-16 15:00:58.16",
        "end_ts" => "2020-09-16 15:01:01.456",
        "fin_extension_version" => "1.05",
        "id" => 1003,
        "is_in_browser" => true,
        "page_host" => "fin.zendesk.com",
        "page_title" => "Zendesk (- Ticket 1234)",
        "page_url" => "https://fin.zendesk.com/ticket/1234",
        "ui_events" => {
            "n_keypress" => 62,
            "n_mouse_click" => 0,
            "n_mouse_move" => 10,
            "n_mouse_scroll" => 1
        },
        "extra" => {
            "array" => ['a']
        },
        "user_id" => 56183
    }
    Processor.new.run_actions(rule_actions, event)
    assert_true event.dig(*(rule_actions.first['keyPath'].to_s[1..-1].to_s.split('.'))).include?(rule_actions.first['value'])
  end

  def test_write_field
    tags = ['category']
    # tags exists, no overwrite
    rule_actions = [{ "action" => "writeField", "keyPath" => "$tags", "value" => [], "overwriteIfExists" => false }]
    event = {
        "begin_ts" => "2020-09-16 15:00:58.16",
        "end_ts" => "2020-09-16 15:01:01.456",
        "fin_extension_version" => "1.05",
        "id" => 1003,
        "is_in_browser" => true,
        "page_host" => "fin.zendesk.com",
        "page_title" => "Zendesk (- Ticket 1234)",
        "page_url" => "https://fin.zendesk.com/ticket/1234",
        "ui_events" => {
            "n_keypress" => 62,
            "n_mouse_click" => 0,
            "n_mouse_move" => 10,
            "n_mouse_scroll" => 1
        },
        "tags" => tags,
        "user_id" => 56183
    }
    Processor.new.run_actions(rule_actions, event)
    assert_equal event.dig(*(rule_actions.first['keyPath'].to_s[1..-1].to_s.split('.'))), tags

    # tags don't exists, no overwrite
    rule_actions = [{ "action" => "writeField", "keyPath" => "$tags", "value" => [], "overwriteIfExists" => false }]
    event = {
        "begin_ts" => "2020-09-16 15:00:58.16",
        "end_ts" => "2020-09-16 15:01:01.456",
        "fin_extension_version" => "1.05",
        "id" => 1003,
        "is_in_browser" => true,
        "page_host" => "fin.zendesk.com",
        "page_title" => "Zendesk (- Ticket 1234)",
        "page_url" => "https://fin.zendesk.com/ticket/1234",
        "ui_events" => {
            "n_keypress" => 62,
            "n_mouse_click" => 0,
            "n_mouse_move" => 10,
            "n_mouse_scroll" => 1
        },
        "user_id" => 56183
    }
    Processor.new.run_actions(rule_actions, event)
    assert_equal event.dig(*(rule_actions.first['keyPath'].to_s[1..-1].to_s.split('.'))), rule_actions.first['value']

    # overwrite
    rule_actions = [{ "action" => "writeField", "keyPath" => "$tags", "value" => [], "overwriteIfExists" => true }]
    Processor.new.run_actions(rule_actions, event)
    assert_equal event.dig(*(rule_actions.first['keyPath'].to_s[1..-1].to_s.split('.'))), rule_actions.first['value']
  end

  def test_full

  end

  def log_debug(msg)
    $stdout.write msg
  end
end
