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
      my_each { |index| return false unless arguments[0] == index }
    elsif !block_given?
      my_each { |index| return false unless index }
    else
      my_each { |index| return false unless yield(index) }
    end
    true
  end

  def my_any?(*arguments)
    if !arguments[0].nil?
      my_each { |index| return true unless arguments[0] == index }
    elsif !block_given?
      my_each { |index| return true unless index }
    else
      my_each { |index| return true unless yield(index) }
    end
    false
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

  def my_inject(*args)
    init = !args.empty?
    value = init ? args[0] : self[0]
    drop(init ? 0 : 1).my_each do |element|
      value = yield(value, element)
    end
    value
  end
end
def multiply_els(array)
  puts '=====multiply_els====='
  puts array.my_inject(1) { |value, i| value * i }
end

test_array = [1, 2, 3, 4, 5]
multiply_els(test_array)
