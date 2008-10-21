require 'lib/hash_extensions'

describe Hash do
  describe 'required_key' do
    it 'should raise an ArgumentError when the required key is not given' do
      lambda{{}.required_key!(:foo)}.should raise_error(ArgumentError)
      lambda{{}.required_key(:foo)}.should raise_error(ArgumentError)
      lambda{{:bar => nil}.required_key(:foo)}.should raise_error(ArgumentError)
      lambda{{:bar => nil}.required_key!(:foo)}.should raise_error(ArgumentError)
      lambda{{:foo => nil}.required_key!(:foo)}.should_not raise_error(ArgumentError)
      lambda{{:foo => nil}.required_key(:foo)}.should_not raise_error(ArgumentError)
    end

    it 'should delete the key only if a bang is used' do
      h = {:foo => nil}
      h.required_key(:foo).should == nil
      h.should have_key(:foo)

      h.required_key!(:foo).should == nil
      h.should_not have_key(:foo)
    end
  end

  describe 'required_keys' do
    it 'should raise an ArgumentError when the required keys are not given' do
      lambda{{}.required_keys(:foo)}.should raise_error(ArgumentError)
      lambda{{:bar => nil}.required_keys(:foo)}.should raise_error(ArgumentError)
      {:foo => nil}.required_keys(:foo).should == [nil]
      {:foo => nil, :bar => ''}.required_keys(:foo).should == [nil]
      {:foo => nil, :bar => ''}.required_keys(:foo, :bar).should == [nil,'']
      lambda{{:foo => nil, :bar => ''}.required_keys(:foo, :bar, :baz)}.should raise_error(ArgumentError)
    end
  end

  describe 'assert_only_keys' do
    it 'should raise an ArgumentError when only the exact keys are not given' do
      lambda{{}.assert_only_keys(:foo)}.should raise_error(ArgumentError)
      lambda{{:bar => nil}.assert_only_keys(:foo)}.should raise_error(ArgumentError)
      {:foo => nil}.assert_only_keys(:foo)
      lambda{{:foo => nil, :bar => ''}.assert_only_keys(:foo)}.should raise_error(ArgumentError)
      {:foo => nil, :bar => ''}.assert_only_keys(:foo, :bar)
      lambda{{:foo => nil, :bar => ''}.assert_only_keys(:foo, :bar, :baz)}.should raise_error(ArgumentError)
    end
  end

  describe 'dup_values' do
    it 'should return a hash whose values are duped' do
      # sanity
      {:a => [], 'b' => 'word'}.dup_values.should == {:a => [], 'b' => 'word'}
      # old
      a = []
      {:a => a}.dup[:a].push(1).should == [1]
      a.should == [1]

      # new
      a = []
      {:a => a}.dup_values[:a].push(1).should == [1]
      a.should == []
    end
  end
end
