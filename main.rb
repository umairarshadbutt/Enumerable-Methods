# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum unless block_given?

    array = to_a
    array.length.times { |index| yield(array[index]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    array = to_a
    array.length.times { |index| yield(array[index], index) }
    self
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each { |index| array.push(index) if yield(index) }
    array
  end

  def my_all?(*arguments)
    return "`all?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1
    if block_given?
      my_each { |index| return false unless yield(index) }

    elsif arguments[0].is_a? Class
      my_each { |index| return false unless index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return false unless arguments[0].match(index) }
    elsif arguments.empty?
      return include?(nil) || include?(false) ? false : true
    else
      my_each { |index| return false unless index == arguments[0] }
    end
    true
  end

  def my_any?(*arguments)
    return "`all?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1
    if block_given?
      my_each { |index| return true unless yield(index) }
    elsif arguments[0].is_a? Class
      my_each { |index| return true unless index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return true unless arguments[0].match(index) }
    elsif arguments.empty?
      return include?(nil) || include?(true) ? true : false
    else
      my_each { |index| return true unless index == arguments[0] }
    end
    false
  end

  def my_none?(*args)
    my_any?(*args)
  end

  def my_count(arg = nil)
    counter = 0
    if arg
      my_each { |element| counter += 1 if element == arg }
    elsif !block_given?
      counter = length
    elsif !arg
      my_each { |element| counter += 1 if yield element }
    end
    counter
  end

  def my_map(proc = nil)
    arr = []
    return to_enum unless block_given?

    if proc
      my_each { |element| arr << proc.call(element) }
    else
      my_each { |element| arr << yield(element) }
    end
    arr
  end

  def my_inject(number = nil, sym = nil)
    if block_given?
      accumulator = number
      my_each { |index| accumulator = accumulator.nil? ? index : yield(accumulator, index) }
      accumulator
    elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
      raise LocalJumpError unless block_given? || !number.empty?
      accumulator = nil
      my_each { |index| accumulator = accumulator.nil? ? index : accumulator.send(number, index) }
      accumulator
    elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
      raise LocalJumpError unless block_given? || !sym.empty?
      accumulator = number
      my_each { |index| accumulator = accumulator.nil? ? index : accumulator.send(sym, index) }
      accumulator
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  puts '=====multiply_els====='
  array.my_inject(:*)
end
test_array = [1, 2, 3, 4, 5]
string_array = %w[Marc Luc Jean]
multiply_els(test_array)
puts '===all vs my_all ==='
puts [1, 5i, 5.67].my_all?(Numeric) #=> true
puts [2, 1, 6, 7, 4, 8, 10].my_all?(Integer) #=> true

puts [1, 5i, 5.67].all?(Numeric) #=> true
puts [2, 1, 6, 7, 4, 8, 10].all?(Integer) #=> true
puts ''
puts '===none vs my_none ==='
print string_array.none? { |text| text.size >= 4 } #=> false
print ' ==vs== '
puts string_array.my_none? { |text| text.size >= 4 } #=> false
print string_array.none?(/j/) #=> true
print ' ==vs== '
puts string_array.my_none?(/j/) #=> true
print [2, 1, 6, 7, 4, 8, 10].none?(15) #=> true
print ' ==vs== '
puts [2, 1, 6, 7, 4, 8, 10].my_none?(15) #=> true
print [nil].none? #=> true
print ' ==vs== '
puts [nil].my_none? #=> true
print [nil, false].none? #=> true
print ' ==vs== '
puts [nil, false].my_none? #=> true
print [nil, nil, nil].none? #=> true
print ' ==vs== '
puts [nil, nil, nil].my_none? #=> true
puts ''
puts '===map vs my_map ==='
arr_proc = proc { |n| n * 2 }
print 'map => '
print [2, 3, 5, 6, 1, 7, 5, 3, 9].map(&arr_proc).map { |n| n + 1 }
puts ''
puts ''
print 'my_map =>'
print [2, 3, 5, 6, 1, 7, 5, 3, 9].my_map(&arr_proc).my_map { |n| n + 1 }
puts ''
puts ''
puts '===inject vs my_inject ==='
print (5..10).inject(:+)
print ' ==vs== '
puts (5..10).my_inject(:+)

print [2, 3, 5, 6, 1, 7, 5, 3, 9].inject(:+)
print ' ==vs== '
puts [2, 3, 5, 6, 1, 7, 5, 3, 9].my_inject(:+)

print (5..10).inject { |sum, n| sum + n }
print ' ==vs== '
puts (5..10).my_inject { |sum, n| sum + n }

print (5..10).inject(1, :*)
print ' ==vs== '
puts (5..10).my_inject(1, :*)

print [2, 3, 5, 6, 1, 7, 5, 3, 9].inject(1, :*)
print ' ==vs== '
puts [2, 3, 5, 6, 1, 7, 5, 3, 9].my_inject(1, :*)
