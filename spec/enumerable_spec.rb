# rubocop:disable Metrics/LineLength
require_relative '../enumerables.rb'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 7, 8, 22, 55, 34, 86] }
  let(:all_odd_array) { [1, 3, 5, 7, 9, 11] }
  let(:negative_array) { [-8, -9, -6] }
  let(:false_array) { [1, false, 'hi', []] }
  describe '#my_each' do
    it 'return an array' do
      expect(array.my_all?(1)).to eq(array.all?(1))
    end
  end

  describe '#my_each_with_index' do
    it 'return the array values' do
      expect(array.my_each_with_index { |elem, idx| }).to eq(array.each_with_index { |elem, idx| })
    end
  end

  describe '#my_select' do
    it 'my_select should return odd array' do
      expect(array.my_select(&:odd?)).to eq(array.select(&:odd?))
    end
  end

  describe '#my_select' do
    it 'my_select should return even array' do
      expect(array.my_select(&:even?)).to eq(array.select(&:even?))
    end
  end

  describe '#my_all' do
    it 'my_all should return true on odd array' do
      expect(all_odd_array.my_all?(&:odd?)).to eq(all_odd_array.all?(&:odd?))
    end
  end

  describe '#my_all' do
    it 'my_all should return true if all values are neagtive' do
      expect(negative_array.my_all? { |n| n < 0 }).to eq(negative_array.all? { |n| n < 0 })
    end
  end

  describe '#my_all' do
    it 'my_all should return true if all values are neagtive' do
      expect(false_array.my_all?).to eq(false_array.all?)
    end
  end
  describe '#my_any' do
    it 'my_any should return true if values are even' do
      expect(array.my_any?(&:even?)).to eq(array.any?(&:even?))
    end
  end

  describe '#my_any' do
    it 'my_any should return true if all charecters are in string' do
      expect(%w[q r s i].my_any? { |char| 'aeiou'.include?(char) }).to eq(%w[q r s i].any? { |char| 'aeiou'.include?(char) })
    end
  end

  describe '#my_any' do
    it 'my_any should return false if numbers in array not even' do
      expect(all_odd_array.my_any?(&:even?)).to eq(all_odd_array.any?(&:even?))
    end
  end

  describe '#my_any' do
    it 'my_any should return false if char are not in string' do
      expect(%w[q r s t].my_any? { |char| 'aeiou'.include?(char) }).to eq(%w[q r s t].any? { |char| 'aeiou'.include?(char) })
    end
  end

  describe '#my_any' do
    it 'my_any should return true' do
      expect([1, nil, false].my_any?(1)).to eq([1, nil, false].any?(1))
    end
  end

  describe '#my_any' do
    it 'my_any should return true if there a integer in array' do
      expect([1, nil, false].my_any?(Integer)).to eq([1, nil, false].any?(Integer))
    end
  end
  describe '#my_any' do
    it 'my_any should return false if a charecter is not found in any elememt' do
      expect(%w[dog door rod blade].my_any?(/z/)).to eq(%w[dog door rod blade].any?(/z/))
    end
  end

  describe '#my_any' do
    it 'my_any should return true if 1 is found in array' do
      expect(array.my_any?(1)).to eq(array.any?(1))
    end
  end

  describe '#my_any' do
    it 'my_any should return true if elements are Numeric in array' do
      expect(array.my_any?(Numeric)).to eq(array.any?(Numeric))
    end
  end

  describe '#my_any' do
    it 'my_any should return true if elements are Integer in array' do
      expect(array.my_any?(Integer)).to eq(array.any?(Integer))
    end
  end

  describe '#my_any' do
    it 'my_any should return false if element is found' do
      expect(%w[jes,umair,jesagain,hello].my_any?('jes')).to eq(%w[jes,umair,jesagain,hello].any?('jes'))
    end
  end

  describe '#my_none' do
    it 'my_none should return true if the elements are even ' do
      expect(all_odd_array.my_none?(&:even?)).to eq(all_odd_array.none?(&:even?))
    end
  end

  describe '#my_none' do
    it 'my_none should return true if a charecter is not found in a element of array ' do
      expect(%w[sushi pizza burrito].my_none? { |word| word[0] == 'a' }).to eq(%w[sushi pizza burrito].none? { |word| word[0] == 'a' })
    end
  end

  describe '#my_none' do
    it 'my_none should return true if the elements are not even  ' do
      expect(array.my_none?(&:even?)).to eq(array.none?(&:even?))
    end
  end

  describe '#my_none' do
    it 'my_none should return false if every element is not starting with a ' do
      expect(%w[asparagus sushi pizza apple burrito].my_none? { |word| word[0] == 'a' }).to eq(%w[asparagus sushi pizza apple burrito].none? { |word| word[0] == 'a' })
    end
  end

  describe '#my_none' do
    it 'my_none should return false if every element is not starting with a ' do
      expect([nil, false, nil, false].my_none?).to eq([nil, false, nil, false].none?)
    end
  end

  describe '#my_none' do
    it 'my_none should return false beacuse  array is not none ' do
      expect(array.my_none?).to eq(array.none?)
    end
  end

  describe '#my_none' do
    it 'my_none should return true beacuse  array are string ' do
      expect(array.my_none?(String)).to eq(array.none?(String))
    end
  end

  describe '#my_none' do
    it 'my_none should return false beacuse there is 2 in array' do
      expect(array.my_none?(2)).to eq(array.none?(2))
    end
  end

  describe '#my_none' do
    it 'my_none should return true because there is no 4 four in array' do
      expect([1, 2, 3].my_none?(4)).to eq([1, 2, 3].my_none?(4))
    end
  end

  describe '#my_count' do
    it 'my_count should return count of even numbers' do
      expect(array.my_count(&:even?)).to eq(array.count(&:even?))
    end
  end

  describe '#my_count' do
    it 'my_count should return count of uper case elements' do
      expect(%w[DANIEL JIA KRITI dave].my_count { |s| s == s.upcase }).to eq(%w[DANIEL JIA KRITI dave].count { |s| s == s.upcase })
    end
  end

  describe '#my_count' do
    it 'my_count should return count of uper case elements' do
      expect(%w[DANIEL JIA KRITI dave].my_count { |s| s == s.upcase }).to eq(%w[DANIEL JIA KRITI dave].count { |s| s == s.upcase })
    end
  end

  describe '#my_count' do
    it 'my_count should return count 1 in array' do
      expect(array.my_count(1)).to eq(array.count(1))
    end
  end

  describe '#my_count' do
    it 'my_count should return elements from 1 to 5' do
      expect((1...5).my_count).to eq((1...5).count)
    end
  end

  describe '#my_map' do
    it 'my_map should return an array of multiply for 2' do
      expect(array.my_map { |n| 2 * n }).to eq(array.map { |n| 2 * n })
    end
  end

  describe '#my_map' do
    it 'my_map should return an array with concat of ?' do
      expect(%w[Hey Jude].my_map { |word| word + '?' }).to eq(%w[Hey Jude].map { |word| word + '?' })
    end
  end

  describe '#my_map' do
    it 'my_map should return with not operation' do
      expect([false, true].my_map(&:!)).to eq([false, true].map(&:!))
    end
  end

  describe '#my_inject' do
    it 'my_inject will return the the array + 10' do
      expect(array.my_inject(10) { |accum, elem| accum + elem }).to eq(array.inject(10) { |accum, elem| accum + elem })
    end
    it 'my_inject will return the sum of array' do
      expect(array.my_inject { |accum, elem| accum + elem }).to eq(array.inject { |accum, elem| accum + elem })
    end
    it 'my_inject will return the multiplication with 2 of array with * symbol' do
      expect(array.my_inject(2, :*)).to eq(array.inject(2, :*))
    end
    it '#my_inject raises a "LocalJumpError" when no block or argument is given Failure/Error' do
      expect { array.my_inject }.to raise_error(LocalJumpError)
    end
  end
end

# rubocop:enable Metrics/LineLength
