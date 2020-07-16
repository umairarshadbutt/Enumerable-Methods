# rubocop:disable Metrics/ModuleLength
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
    return "`my_any?': wrong number of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |index| return true if yield(index) }
    elsif arguments.empty?
      my_each { |index| return true if index }
      return false
    elsif arguments[0].is_a? Class
      my_each { |index| return true if index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return true if arguments[0].match(index) }
    else
      my_each { |index| return true if index == arguments[0] }
    end
    false
  end

  def my_none?(*arguments)
    return "`my_none?': wrong number of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |index| return false if yield(index) }
    elsif arguments.empty?
      my_each { |index| return false unless index.nil? || index == false }
    elsif arguments[0].is_a? Class
      my_each { |index| return false if index.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |index| return false if arguments[0].match(index) }
    else
      my_each { |index| return false if index == arguments[0] }
    end
    true
  end

  def my_count(*arguments)
    counter = 0
    if block_given?
      my_each { |element| counter += 1 if yield(element) }
    elsif arguments.empty?
      counter = to_a.length
    else
      to_a.my_each { |element| counter += 1 if element == arguments[0] }
    end
    return "`my_count?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

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
      raise LocalJumpError unless block_given? || !sym.empty? || !number.empty?
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
    else
      raise LocalJumpError unless block_given? || !sym.empty? || !number.empty?
    end
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  array.my_inject(:*)
end
