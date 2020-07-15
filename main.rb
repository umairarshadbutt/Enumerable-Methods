# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    array.length.times { |index| yield(array[index]) }
    self
  end

  def my_each_with_index
    return enum_for unless block_given?

    array = is_a?(Range) ? to_a : self
    array.length.times { |index| yield(array[index], index) }
    self
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
    elsif arguments[0].is_a? Class
      my_each { |index| return true unless index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return true unless arguments[0].match(index) }
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
    elsif arguments[0].is_a? Class
      my_each { |index| return false unless index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return false unless arguments[0].match(index) }
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
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  puts '=====multiply_els====='
  array.my_inject(:*)
end
test_array = [1, 2, 3, 4, 5]
multiply_els(test_array)
