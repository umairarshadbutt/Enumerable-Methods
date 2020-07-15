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
    return "`my_all?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

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
    return "`my_any?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

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
    return_value = true
    if block_given?
      self.my_each do |el|
        return_value = false if yield(el) == true
      end
    elsif args[0].is_a? Class
      self.my_each { |index| return_value = true unless index.class.ancestors.include?(args[0]) }
    elsif args[0].is_a? Regexp
      self.my_each { |index| return_value = false unless args[0].match(index) }
    elsif args.empty?
      return include?(nil) || include?(true) ? return_value = true : return_value = false
    else
      self.my_each { |index| return_value = true unless index == args[0] }
    end
    return_value
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
  array.my_inject(:*)
end


# 6. my_none? (example test cases)
puts "My None Method"
p [3, 5, 7, 11].my_none? { |n| n.even? } # => true
p ["sushi", "pizza", "burrito"].my_none? { |word| word[0] == "a" } # => true
p [3, 5, 4, 7, 11].my_none? { |n| n.even? } # => false (Not working)
p ["asparagus", "sushi", "pizza", "apple", "burrito"].my_none? { |word| word[0] == "a" } # => false (Not working)
# test cases required by tse reviewer
p [nil, false, nil, false].my_none? # => true
p [1, 2 ,3].my_none? # => false
p [1, 2 ,3].my_none?(String) # => true
p [1,2,3,4,5].my_none?(2) # => false
p [1, 2, 3].my_none?(4) # => true

puts "Origina None"
p [3, 5, 7, 11].none? { |n| n.even? } # => true
p ["sushi", "pizza", "burrito"].none? { |word| word[0] == "a" } # => true
p [3, 5, 4, 7, 11].none? { |n| n.even? } # => false (Not working)
p ["asparagus", "sushi", "pizza", "apple", "burrito"].none? { |word| word[0] == "a" } # => false (Not working)
# test cases required by tse reviewer
p [nil, false, nil, false].none? # => true
p [1, 2 ,3].none? # => false
p [1, 2 ,3].none?(String) # => true
p [1,2,3,4,5].none?(2) # => false
p [1, 2, 3].none?(4) # => true