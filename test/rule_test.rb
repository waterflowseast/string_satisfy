require 'test_helper'

class RuleTest < MiniTest::Unit::TestCase
  def setup
    @object = StringSatisfy::Rule.new 'rule'
    @rule = StringSatisfy::Rule.new('a', @object, 'a', @object, 'b')
  end

  def test_objects_are_uniq
    uniq_objects = @rule.instance_exec { @rules_array }

    assert_equal 3, uniq_objects.size
    assert_equal ['a', @object, 'b'], uniq_objects
  end

  def test_rule_objects
    assert_equal [@object], @rule.rule_objects
  end

  def test_normal_objects
    assert_equal ['a', 'b'], @rule.normal_objects
  end
end

class AndRuleTest < MiniTest::Unit::TestCase
  def setup
    @low = StringSatisfy::AndRule.new('a', 'b')
    @mid = StringSatisfy::AndRule.new('c', @low)
    @high = StringSatisfy::AndRule.new('d', @mid)
  end

  def test_one_level_satisfied_with
    assert_equal false, @low.satisfied_with?
    assert_equal false, @low.satisfied_with?('')
    assert_equal false, @low.satisfied_with?('a')
    assert_equal true, @low.satisfied_with?('a', 'b')
  end

  def test_two_levels_satisfied_with
    assert_equal false, @mid.satisfied_with?
    assert_equal false, @mid.satisfied_with?('')
    assert_equal false, @mid.satisfied_with?('a', 'b')
    assert_equal true, @mid.satisfied_with?('a', 'b', 'c')
  end

  def test_three_levels_satisfied_with
    assert_equal false, @high.satisfied_with?
    assert_equal false, @high.satisfied_with?('')
    assert_equal false, @high.satisfied_with?('a', 'b', 'c')
    assert_equal true, @high.satisfied_with?('a', 'b', 'c', 'd')
  end
end

class OrRuleTest < MiniTest::Unit::TestCase
  def setup
    @low = StringSatisfy::OrRule.new('a', 'b')
    @mid = StringSatisfy::OrRule.new('c', @low)
    @high = StringSatisfy::OrRule.new('d', @mid)
  end

  def test_one_level_satisfied_with
    assert_equal false, @low.satisfied_with?
    assert_equal false, @low.satisfied_with?('')
    assert_equal true, @low.satisfied_with?('a')
    assert_equal true, @low.satisfied_with?('a', 'b')
  end

  def test_two_levels_satisfied_with
    assert_equal false, @mid.satisfied_with?
    assert_equal false, @mid.satisfied_with?('')
    assert_equal true, @mid.satisfied_with?('a')
    assert_equal true, @mid.satisfied_with?('c')
    assert_equal true, @mid.satisfied_with?('a', 'c')
  end

  def test_three_levels_satisfied_with
    assert_equal false, @high.satisfied_with?
    assert_equal false, @high.satisfied_with?('')
    assert_equal true, @high.satisfied_with?('a')
    assert_equal true, @high.satisfied_with?('c')
    assert_equal true, @high.satisfied_with?('d')
    assert_equal true, @high.satisfied_with?('a', 'c')
    assert_equal true, @high.satisfied_with?('a', 'd')
  end
end

class MixAndRuleTest < MiniTest::Unit::TestCase
  # (A|B) & (C|D) & E
  def setup
    @or1 = StringSatisfy::OrRule.new('a', 'b')
    @or2 = StringSatisfy::OrRule.new('c', 'd')
    @mix = StringSatisfy::AndRule.new(@or1, @or2, 'e')
  end

  def test_satisfied_with
    assert_equal false, @mix.satisfied_with?
    assert_equal false, @mix.satisfied_with?('')
    assert_equal false, @mix.satisfied_with?('a')
    assert_equal false, @mix.satisfied_with?('e')
    assert_equal false, @mix.satisfied_with?('a', 'b')
    assert_equal false, @mix.satisfied_with?('a', 'c')
    assert_equal false, @mix.satisfied_with?('a', 'e')
    assert_equal true, @mix.satisfied_with?('a', 'c', 'e')
    assert_equal true, @mix.satisfied_with?(*%w(a b c d e))
  end
end

class MixOrRuleTest < MiniTest::Unit::TestCase
  # (A&B) | (C&D) | E
  def setup
    @and1 = StringSatisfy::AndRule.new('a', 'b')
    @and2 = StringSatisfy::AndRule.new('c', 'd')
    @mix = StringSatisfy::OrRule.new(@and1, @and2, 'e')
  end

  def test_satisfied_with
    assert_equal false, @mix.satisfied_with?
    assert_equal false, @mix.satisfied_with?('')
    assert_equal false, @mix.satisfied_with?('a')
    assert_equal false, @mix.satisfied_with?('a', 'c')
    assert_equal true, @mix.satisfied_with?('a', 'b')
    assert_equal true, @mix.satisfied_with?('e')
    assert_equal true, @mix.satisfied_with?('a', 'c', 'e')
    assert_equal true, @mix.satisfied_with?(*%w(a b c d e))
  end
end
