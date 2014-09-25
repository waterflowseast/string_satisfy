require 'test_helper'

class StringSatisfyTest < MiniTest::Unit::TestCase
  SS = StringSatisfy

  def test_parens_not_match
    assert_raises(SS::ParensNotMatchError) { SS.new('(') }
    assert_raises(SS::ParensNotMatchError) { SS.new(')') }
    assert_raises(SS::ParensNotMatchError) { SS.new(')(') }
    assert_raises(SS::ParensNotMatchError) { SS.new(')()') }
    assert_raises(SS::ParensNotMatchError) { SS.new(')()(') }
  end

  def test_empty_pattern
    object = SS.new ''
    assert_equal false, object.satisfied_with?
    assert_equal true, object.satisfied_with?('')
    assert_equal false, object.satisfied_with?('a')
  end

  def test_duplicated_and_pattern
    object = SS.new 'a & a & a'
    assert_equal false, object.satisfied_with?
    assert_equal false, object.satisfied_with?('')
    assert_equal true, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'a')
    assert_equal true, object.satisfied_with?('a', 'a', 'a')
  end

  def test_duplicated_or_pattern
    object = SS.new 'a | a | a'
    assert_equal false, object.satisfied_with?
    assert_equal false, object.satisfied_with?('')
    assert_equal true, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'a')
    assert_equal true, object.satisfied_with?('a', 'a', 'a')
  end

  def test_duplicated_mix_pattern
    object = SS.new 'a | a & a | a'
    assert_equal false, object.satisfied_with?
    assert_equal false, object.satisfied_with?('')
    assert_equal true, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'a')
    assert_equal true, object.satisfied_with?('a', 'a', 'a')
  end

  def test_only_and_pattern
    object = SS.new 'a & b & c'
    assert_equal false, object.satisfied_with?('')
    assert_equal false, object.satisfied_with?('a')
    assert_equal false, object.satisfied_with?('a', 'b')
    assert_equal true, object.satisfied_with?('a', 'b', 'c')
  end

  def test_only_or_pattern
    object = SS.new 'a | b | c'
    assert_equal false, object.satisfied_with?('')
    assert_equal true, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'b')
    assert_equal true, object.satisfied_with?('a', 'b', 'c')
  end

  def test_mix_pattern
    object = SS.new '(a & b) | (c & d) | e'
    assert_equal false, object.satisfied_with?('')
    assert_equal false, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'b')
    assert_equal false, object.satisfied_with?('a', 'c')
    assert_equal true, object.satisfied_with?('e')
    assert_equal true, object.satisfied_with?('a', 'c', 'e')
  end

  def test_simple_extra_parens
    object = SS.new '(a) & (b)'
    assert_equal false, object.satisfied_with?('')
    assert_equal false, object.satisfied_with?('a')
    assert_equal true, object.satisfied_with?('a', 'b')
  end

  def test_complicated_extra_parens
    # same effect as: "(a | b) & (c | d) & e"
    object = SS.new '(( (a | (b)) & ((c) | (d)) & (e) ))'
    assert_equal false, object.satisfied_with?('')
    assert_equal false, object.satisfied_with?('a')
    assert_equal false, object.satisfied_with?('b')
    assert_equal false, object.satisfied_with?('c')
    assert_equal false, object.satisfied_with?('e')
    assert_equal false, object.satisfied_with?('a', 'b')
    assert_equal false, object.satisfied_with?('a', 'c')
    assert_equal false, object.satisfied_with?('b', 'c')
    assert_equal true, object.satisfied_with?('a', 'c', 'e')
    assert_equal true, object.satisfied_with?('b', 'd', 'e')
  end

  def test_no_parens
    # same effect as "a | (b & c) | (d & e)"
    object = SS.new 'a | b & c | d & e'
    assert_equal false, object.satisfied_with?('')
    assert_equal true, object.satisfied_with?('a')
    assert_equal false, object.satisfied_with?('b')
    assert_equal false, object.satisfied_with?('b', 'd')
    assert_equal true, object.satisfied_with?('b', 'c')
    assert_equal true, object.satisfied_with?('a', 'b')
    assert_equal true, object.satisfied_with?('a', 'b', 'd')
    assert_equal true, object.satisfied_with?(*%w(a b c d e))
  end
end
