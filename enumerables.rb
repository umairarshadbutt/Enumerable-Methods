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

  def my_map(&block)
    arr = []
    my_each { |element| arr << block.call(element) }
    arr
  end

  def my_inject(*args)
    init = args.size > 0
    value = init ? args[0] : self[0]
    self.drop(init ? 0 : 1).my_each do |element|
      value = yield(value, element)
    end
    return value
  end

end

test_array = [1, 2, 3, 4, 5]
puts '==========my_each========='
(0..test_array.length).my_each { |index| print test_array[index] }
puts ''
puts '====my_each_with_index===='
test_array.my_each_with_index { |val, index| puts "Element #{val} is on index #{index}" }
friends = %w[Sharon Leo Leila Brian Arun]

friends.my_select { |friend| friend != 'Brian' }
puts friends

puts [nil, true, 99].my_all?

puts '----------MY COUNT------------'
puts friends.my_count

puts "--------MY MAP---------------"
puts friends.my_map { |el| el.upcase }

puts '------------MY ANY--------------'
puts test_array.my_any? { |num| num == 3 }

puts '------------MY NONE--------------'
test_arr = [nil, false]
puts test_arr.my_none?

puts '------------INject--------------'
puts [1,2,3,4].my_inject(1) { |value, i| value*i}
