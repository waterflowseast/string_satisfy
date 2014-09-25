require "string_satisfy/version"
require "string_satisfy/rule"
require "string_satisfy/error"
require "string_satisfy/utils"

class StringSatisfy
  def initialize(pattern)
    unless Utils.valid_parens_string? pattern
      raise ParensNotMatchError, 'Parentheses are not matched.'
    end

    @pattern = pattern
    @rule_object = Utils.construct_rule_object pattern
  end

  def satisfied_with?(*objects)
    @rule_object.satisfied_with? *objects
  end
end
