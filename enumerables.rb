module Enumerables
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

  def my_select; end

  def my_all; end

  def my_any; end

  def my_none; end

  def my_count; end

  def my_map; end

  def my_inject; end
end
