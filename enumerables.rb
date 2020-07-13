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

end

test_array = [1, 2, 3, 4, 5]
puts '==========my_each========='
(0..test_array.length).my_each { |index| print test_array[index] }
puts ''
puts '====my_each_with_index===='
test_array.my_each_with_index { |val, index| puts "Element #{val} is on index #{index}" }
friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']

friends.my_select { |friend| friend != 'Brian' }
puts friends
