class StringSatisfy
  module Utils
    extend self

    def valid_parens_string?(str)
      str = str.gsub /[^\(\)]/, ''
      deep_level = 0

      str.chars do |char|
        if char == '('
          deep_level += 1
        else
          if deep_level > 0
            deep_level -= 1
          else
            return false
          end
        end
      end

      deep_level == 0 ? true : false
    end

    # "(A)"               will become "A"
    # "(( A ))"           will become "A"
    # " (  ) "            will become ""
    # "(A & ( B | C ))"   will become "A&(B|C)"
    # "(A | B) & (C | D)" will become "(A|B)&(C|D)"
    #
    def strip_outer_parens(str)
      str = str.gsub /\s+/, ''

      while str =~ /^\((.*)\)$/
        valid_parens_string?($1) ? str = $1 : break
      end

      str
    end

    # input:  string
    # output: [replaced_string, array of parens string]
    #
    # example
    # ============================
    # input:  "(A | B) & (C | D)"
    # output:
    # [
    #   "[__0__]&[__1__]",
    #   ["(A|B)", "(C|D)"]
    # ]
    #
    # explanation:
    # ============================
    # string will be replaced with [__0__] format if it matches parens,
    # 0 stands for it is 0-index in the parsed array
    #
    def replace_parens_group(str)
      str = strip_outer_parens str

      deep_level = 0
      replaced_str = ''
      tmp_str = ''
      parens_array = []

      str.chars do |char|
        case char
        when '('
          deep_level += 1
          tmp_str << '('
        when ')'
          deep_level -= 1
          tmp_str << ')'
          if deep_level == 0
            replaced_str << "[__#{parens_array.size}__]"
            parens_array << tmp_str.dup
            tmp_str.clear
          end
        else
          (deep_level > 0 ? tmp_str : replaced_str) << char
        end
      end

      [replaced_str, parens_array]
    end

    def construct_rule_object(pattern)
      replaced_str, parens_array = replace_parens_group(pattern)

      and_count = replaced_str.count '&'
      or_count = replaced_str.count '|'

      return OrRule.new(replaced_str) if and_count == 0 and or_count == 0

      if and_count > 0 and or_count > 0
        object_array = 
          replaced_str.split('|').map do |element|
            if element.include? '&'
              new_element = element.gsub(/\[__(\d+)__\]/) {|match| parens_array[$1.to_i] }
              construct_rule_object(new_element)
            else
              generate_rule_element(element, parens_array)
            end
          end

        return OrRule.new(*object_array)
      end

      if and_count > 0
        rule = '&'
        rule_class = AndRule
      else
        rule = '|'
        rule_class = OrRule
      end

      object_array = replaced_str.split(rule).map {|element| generate_rule_element(element, parens_array) }
      rule_class.new *object_array
    end

    def generate_rule_element(str, parens_array)
      str =~ /^\[__(\d+)__\]$/ ? construct_rule_object(parens_array[$1.to_i]) : str
    end
  end
end
