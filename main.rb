module Enumerable
  def my_each
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    array.length.times { |index| yield(array[index]) }
    array
  end

  def my_each_with_index
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    array.length.times { |index| yield(array[index], index) }
    array
  end

  def my_select
    return enum_for unless block_given?

    array = []
    my_each { |index| array.push(index) if yield(index) }
    array
  end

  def my_all?(*arguments)
    if !arguments[0].nil?
      my_each { |index| return true unless arguments[0] == index }
    elsif !block_given?
      my_each { |index| return true unless index }
    else
      my_each { |index| return true unless yield(index) }
    end
    false
  end

  def my_any?(*arguments)
    if !arguments[0].nil?
      my_each { |index| return false unless arguments[0] == index }
    elsif !block_given?
      my_each { |index| return false unless index }
    else
      my_each { |index| return false unless yield(index) }
    end
    true
  end

  def my_none?(*args)
    !my_any?(*args)
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

  def my_map
    arr = []
    my_each { |element| arr << yield(element) }
    arr
  end

  def my_inject(number = nil, sym = nil)
    if block_given?
      accumulator = number
      my_each { |index| accumulator = accumulator.nil? ? index : yield(accumulator, index) }
      accumulator
    elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
      accumulator = nil
      my_each { |index| accumulator = accumulator.nil? ? index : accumulator.send(number, index) }
      accumulator
    elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
      accumulator = number
      my_each { |index| accumulator = accumulator.nil? ? index : accumulator.send(sym, index) }
      accumulator
    end
  end
end
def multiply_els(array)
  puts '=====multiply_els====='
  puts array.my_inject(1) { |value, i| value * i }
end

test_array = [1, 2, 3, 4, 5]
multiply_els(test_array)
# string_array = %w[Marc Luc Jean]
# puts '===all vs my_all ==='
# puts [1, 5i, 5.67].my_all?(Numeric) #=> true
# puts [2, 1, 6, 7, 4, 8, 10].my_all?(Integer) #=> true

# puts [1, 5i, 5.67].all?(Numeric) #=> true
# puts [2, 1, 6, 7, 4, 8, 10].all?(Integer) #=> true
# puts '===none vs my_none ==='
# print string_array.none? { |text| text.size >= 4 } #=> false
# print ' ==vs== '
# puts string_array.my_none? { |text| text.size >= 4 } #=> false
# print string_array.none?(/j/) #=> true
# print ' ==vs== '
# puts string_array.my_none?(/j/) #=> true
# print [2, 1, 6, 7, 4, 8, 10].none?(15) #=> true
# print ' ==vs== '
# puts [2, 1, 6, 7, 4, 8, 10].my_none?(15) #=> true
# print [nil].none? #=> true
# print ' ==vs== '
# puts [nil].my_none? #=> true
# print [nil, false].none? #=> true
# print ' ==vs== '
# puts [nil, false].my_none? #=> true
# print [nil, nil, nil].none? #=> true
# print ' ==vs== '
# puts [nil, nil, nil].my_none? #=> true

# puts '===map vs my_map ==='
# arr_proc = proc { |n| n * 2 }
# print 'map => '
# print [2, 3, 5, 6, 1, 7, 5, 3, 9].map(&arr_proc).map { |n| n + 1 }
# puts ''
# print 'my_map =>'
# print [2, 3, 5, 6, 1, 7, 5, 3, 9].my_map(&arr_proc).my_map { |n| n + 1 }

# puts '===map vs my_map ==='
# print (5..10).inject(:+)
# print ' ==vs== '
# puts (5..10).my_inject(:+)

# print [2, 3, 5, 6, 1, 7, 5, 3, 9].inject(:+)
# print ' ==vs== '
# puts [2, 3, 5, 6, 1, 7, 5, 3, 9].my_inject(:+)

# print (5..10).inject { |sum, n| sum + n }
# print ' ==vs== '
# puts (5..10).my_inject { |sum, n| sum + n }

# print (5..10).inject(1, :*)
# print ' ==vs== '
# puts (5..10).my_inject(1, :*)

# print [2, 3, 5, 6, 1, 7, 5, 3, 9].inject(1, :*)
# print ' ==vs== '
# puts [2, 3, 5, 6, 1, 7, 5, 3, 9].my_inject(1, :*)
