require_relative '../enumerables.rb'
describe Enumerable do
  describe '#my_each' do
    it 'return a array' do
      expect([1, 2, 3, 4].my_each).to eq([1, 2, 3, 4])
    end
  end
end
