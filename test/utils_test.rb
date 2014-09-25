require 'test_helper'

class ValidParensStringTest < MiniTest::Unit::TestCase
  Utils = StringSatisfy::Utils

  def test_without_parens
    assert_equal true, Utils.valid_parens_string?('')
    assert_equal true, Utils.valid_parens_string?(' ')
    assert_equal true, Utils.valid_parens_string?('a')
    assert_equal true, Utils.valid_parens_string?(' a ')
  end

  def test_parens_count_not_match
    assert_equal false, Utils.valid_parens_string?('(')
    assert_equal false, Utils.valid_parens_string?(')')
    assert_equal false, Utils.valid_parens_string?(')()')
  end

  def test_parens_order_not_match
    assert_equal false, Utils.valid_parens_string?(')(')
    assert_equal false, Utils.valid_parens_string?(')()(')
  end
end

class StripOuterParensTest < MiniTest::Unit::TestCase
  Utils = StringSatisfy::Utils

  def test_without_parens
    assert_equal '', Utils.strip_outer_parens('')
    assert_equal '', Utils.strip_outer_parens(' ')
    assert_equal 'a', Utils.strip_outer_parens(' a ')
  end

  def test_with_only_outer_parens
    assert_equal '', Utils.strip_outer_parens(' ( ) ')
    assert_equal 'a', Utils.strip_outer_parens('(a)')
    assert_equal 'a', Utils.strip_outer_parens('((a))')
  end

  def test_with_mix_parens
    assert_equal 'a&(b|c)', Utils.strip_outer_parens('(a & ( b | c ))')
    assert_equal '(a|b)&(c|d)', Utils.strip_outer_parens('(a | b) & (c | d)')
    assert_equal '(a|b)&(c|d)', Utils.strip_outer_parens('((a | b) & (c | d))')
  end
end

class ReplaceParensGroup < MiniTest::Unit::TestCase
  Utils = StringSatisfy::Utils

  def test_without_parens
    result = [ "a&b", [] ]
    assert_equal result, Utils.replace_parens_group("a & b")
  end

  def test_with_outer_parens
    result = [ "a&b", [] ]
    assert_equal result, Utils.replace_parens_group("( a & b )")
  end

  def test_with_inner_parens
    result = [ "[__0__]&c", ['(a|b)'] ]
    assert_equal result, Utils.replace_parens_group("(a | b) & c")
  end

  def test_with_multiple_inner_parens
    result = [ "[__0__]&[__1__]", ['(a|b)', '(c|d)'] ]
    assert_equal result, Utils.replace_parens_group("(a | b) & (c | d)")
  end
end
