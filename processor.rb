require 'logger'

class Processor
  OR_OP = 'any'
  AND_OP = 'all'
  OPS = { AND_OP => :&, OR_OP => :| }

  attr_reader :rules_set

  def initialize(rules_set = {})
    @rules_set = rules_set
    init_logger
  end
  
  def process(event)
    @logger.info "Processing event #{event['id']}"
    result_event = nil
    @rules_set['rules'].each do |rule|
      condition_result = build_expression(rule['conditions'], event)
      @logger.info 'condition result'
      @logger.info condition_result.inspect
      if !condition_result || (condition_result && !run_actions(rule['actions'], event).nil?)
        result_event = event
      end
    end
    @logger.info "RESULTS"
    @logger.info result_event.inspect
    result_event
  end
  
  def build_expression(conditions, event)
    if conditions.is_a?(Hash) && OPS.keys.include?(conditions.keys.first.to_s)
      condition_operator = conditions.keys.first.to_s
      boolean_expression(conditions[condition_operator], condition_operator, event)
    end  
  end  
  
  def boolean_expression(array, op, event)
    array.map { |x|
      expression = build_expression(x, event) 
      execute_condition(parse_condition(x), event) if expression.nil?
    }.inject(&OPS[op])
  end  
  
  def parse_condition(rule_condition)
    left = rule_condition['left'].to_s[0].eql?('$') ? rule_condition['left'][1..-1].split('.') : rule_condition['left']
    { 
      left: left,
      right: rule_condition['right'],
      operator: rule_condition['operator'].gsub(/(.)([A-Z])/,'\1_\2').downcase
    }
  end  

  def execute_condition(options, event)
    res = send(options[:operator], event.dig(*options[:left]), options[:right])
    if res 
      @logger.info "Condition met for event: #{event['id']}"
      @logger.info event.inspect
      @logger.info options.inspect
    end
    res
  end  
  
  def run_actions(rule_actions, event)
    res = rule_actions.map do |rule_action|
      execute_action(rule_action, event)
    end
    @logger.info "run action results"
    @logger.info res.inspect
    res.include?(nil) ? nil : res     
  end  

  def parse_action(rule_action)
    {
      action: rule_action['action'].gsub(/(.)([A-Z])/,'\1_\2').downcase,
      key_path: rule_action['keyPath'].to_s[1..-1].to_s.split('.'),
      pattern: rule_action['pattern'],
      replacement: rule_action['replacement'],
      value: rule_action['value'],
      overwrite: rule_action['overwriteIfExists']
    }
  end  
  
  def execute_action(rule_action, event)
    options = parse_action(rule_action)
    @logger.info "Running action -#{options[:action]}- on event #{event['id']}"
    if self.class.private_method_defined?(options[:action].to_sym)
      self.send(options[:action], event, options)
    else
      raise "Undefined method: #{options[:action]}"
    end
  end
  
  private

  #
  # ACTIONS
  #
  def array_append(event, options)
    event.dig(*options[:key_path]) << options[:value]
  end

  def drop_event(_event, _options)
    @logger.info "dropping"
    nil
  end
    
  def regex_replace(event, options)
    @logger.info "Action: regex_replace"
    @logger.info 'replacing'
    @logger.info options.inspect
    if options[:pattern][0].eql?('(') && options[:pattern][-1].eql?(')')
      pattern = options[:pattern].gsub('(', '\(').gsub(')', '\)')
    else
      pattern = options[:pattern]
    end
    event.dig(*options[:key_path]).gsub!(Regexp.new(pattern), options[:replacement])
  end
    
  def write_field(event, options)
    @logger.info "Action: write_field"
    h_update = { options[:key_path].last => options[:value] }
    options[:key_path][0..-2].reverse.each { |x| h_update = { x => h_update } }
    if options[:overwrite] || event.dig(*options[:key_path]).nil?
      @logger.info "updating event"
      event.merge!(h_update)
    else
      @logger.info "no update"
      false
    end
  end

  #
  # CONDITIONS
  #
  def equal_to(left, right)
    left == right
  end  
  
  def not_equal_to(left, right)
    !(left == right)
  end  
  
  def greater_than(left, right)
    left > right
  end  
  
  def greater_than_equal(left, right)
    left >= right
  end  
  
  def less_than(left, right)
    left < right
  end  
  
  def less_than_equal(left, right)
    left <= right
  end  
  
  def matches_regex(left, right)
    !left.match(Regexp.new(right)).nil?
  end

  #
  # LOG
  #
  def init_logger
    # @logger = Logger.new(STDOUT)
    @logger = Logger.new('processor.log')
    @logger.level = Logger::DEBUG
  end

  def log(msg)
    @logger.info(msg)
  end

end