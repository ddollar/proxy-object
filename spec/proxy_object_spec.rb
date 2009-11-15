require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'proxy_object'

describe "ProxyObject" do

  before(:each) do
    @object = []
    @object.extend ProxyObject
  end

  it "can add a proxy method" do
    lambda { @object.proxy(:add, mock, :test) }.should_not raise_error
  end

  describe "with a proxy" do
    before(:each) do
      @target = mock
      @object.proxy(:test, @target, :foo)
    end

    it "calls the target's method" do
      @target.should_receive(:foo)
      @object.test
    end

    it "can take arguments" do
      @target.should_receive(:foo).with('bar')
      @object.test('bar')
    end

    it "can take a block" do
      def @target.foo; yield; end

      @actor = mock
      @actor.should_receive(:foo).and_return('bar')
      @object.test { @actor.foo.should == 'bar' }
    end
  end

end
