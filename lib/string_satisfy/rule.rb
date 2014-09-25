class StringSatisfy
  # Base class for rule
  class Rule
    def initialize(*args)
      @rules_array = args.uniq
    end

    def rule_objects
      @rules_array.select {|ele| ele.kind_of? Rule }
    end

    def normal_objects
      @rules_array - rule_objects
    end
  end

  # Boolean test for 'and' rule, like A & B
  class AndRule < Rule
    def satisfied_with?(*objects)
      objects = objects.map {|object| object.gsub(/\s+/, '') }.uniq
      return false unless normal_objects.all? {|normal_object| objects.include? normal_object }
      return false unless rule_objects.all? {|rule_object| rule_object.satisfied_with? *objects }
      true
    end
  end

  # Boolean test for 'or' rule, like A | B
  class OrRule < Rule
    def satisfied_with?(*objects)
      objects = objects.map {|object| object.gsub(/\s+/, '') }.uniq
      return true if normal_objects.any? {|normal_object| objects.include? normal_object }
      return true if rule_objects.any? {|rule_object| rule_object.satisfied_with? *objects }
      false
    end
  end
end
