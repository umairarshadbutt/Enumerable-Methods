# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum unless block_given?

    array = to_a
    array.length.times { |element| yield(array[element]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    array = to_a
    array.length.times { |element| yield(array[element], element) }
    self
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each { |element| array.push(element) if yield(element) }
    array
  end

  def my_all?(*arguments)
    return "`my_all?': wrong # of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |element| return false unless yield(element) }

    elsif arguments[0].is_a? Class
      my_each { |element| return false unless element.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |element| return false unless arguments[0].match(element) }
    elsif arguments.empty?
      return include?(nil) || include?(false) ? false : true
    else
      my_each { |element| return false unless element == arguments[0] }
    end
    true
  end

  def my_any?(*arguments)
    return "`my_any?': wrong number of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |element| return true if yield(element) }
    elsif arguments.empty?
      my_each { |element| return true if element }
      return false
    elsif arguments[0].is_a? Class
      my_each { |element| return true if element.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |element| return true if arguments[0].match(element) }
    else
      my_each { |element| return true if element == arguments[0] }
    end
    false
  end

  def my_none?(*arguments)
    return "`my_none?': wrong number of arguments (given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |element| return false if yield(element) }
    elsif arguments.empty?
      my_each { |element| return false unless element.nil? || element == false }
    elsif arguments[0].is_a? Class
      my_each { |element| return false if element.class.ancestors.include?(arguments[0]) }
    elsif arguments[0].is_a? Regexp
      my_each { |element| return false if arguments[0].match(element) }
    else
      my_each { |element| return false if element == arguments[0] }
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
      my_each { |element| accumulator = accumulator.nil? ? element : yield(accumulator, element) }
      raise LocalJumpError unless block_given? || !sym.empty? || !number.empty?

      accumulator
    elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
      raise LocalJumpError unless block_given? || !number.empty?

      accumulator = nil
      my_each { |element| accumulator = accumulator.nil? ? element : accumulator.send(number, element) }
      accumulator
    elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
      raise LocalJumpError unless block_given? || !sym.empty?

      accumulator = number
      my_each { |element| accumulator = accumulator.nil? ? element : accumulator.send(sym, element) }
      accumulator
    else
      raise LocalJumpError
    end
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  array.my_inject(:*)
end
