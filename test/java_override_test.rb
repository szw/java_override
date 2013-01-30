require 'helper'
require 'java'
require 'java/override'
require 'shoulda'
require 'fileutils'

java_iface = File.join('test', 'java', 'TestInterface.java')
java_class = File.join('test', 'java', 'TestSuperclass.java')

`javac -d . #{java_iface} #{java_class}`

java_import "TestInterface"
java_import "TestSuperclass"

FileUtils.rm 'TestInterface.class'
FileUtils.rm 'TestSuperclass.class'

class JavaOverrideTest < Test::Unit::TestCase
  def setup
    @my_class = MyClass.new
  end

  should "have version" do
    version = Java::Override.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

  should "override simple methods" do
    assert_equal "MyClass: TestSuperclass#myLongMethodName", @my_class.my_long_method_name
    assert_equal "MyClass: TestSuperclass#myLongMethodName", @my_class.myLongMethodName
  end

  should "override javabean accessors" do
    @my_class.foo = 'FOO'

    assert_equal "MyClassGetter: MyClassSetter: FOO", @my_class.foo
    assert_equal "MyClassGetter: MyClassSetter: FOO", @my_class.getFoo

    test_superclass = TestSuperclass.new

    assert test_superclass.foo_bar?
    assert test_superclass.isFooBar

    refute @my_class.foo_bar?
    refute @my_class.isFooBar
  end

  should "not add aliases for private methods" do
    assert MyClass.private_instance_methods(true).include?(:my_private_method)
    refute MyClass.private_instance_methods(true).include?(:myPrivateMethod)
    refute MyClass.instance_methods(false).include?(:myPrivateMethod)
  end

  should "add method_added only to the singleton class even if included" do
    refute_respond_to @my_class, :method_added
    refute MyClass.instance_methods.include?(:method_added)
  end

  should "add method_added as a private singleton method" do
    assert MyClass.private_methods.include?(:method_added)
    assert MyClass.class.private_instance_methods(true).include?(:method_added)
  end

  should "handle names with abbreviations written in upper case" do
    assert_equal "MyClass: TestSuperclass#myLongMethodNameWithABBRV", @my_class.my_long_method_name_with_abbrv
    assert_equal "MyClass: TestSuperclass#myLongMethodNameWithABBRV", @my_class.myLongMethodNameWithABBRV
  end

  should "handle plain method names" do
    assert_equal "MyClass: TestSuperclass#method", @my_class.method
  end

  should "handle protected methods" do
    assert_equal "MyClass: TestSuperclass#protectedMethod", @my_class.test_protected_method
    assert_equal "MyClass: TestSuperclass#protectedMethod", @my_class.testProtectedMethod
  end

  should "handle interface methods" do
    assert_equal "MyInterface#methodMyInterface#my_long_method_name_with_abbrv", @my_class.testInterface(MyInterfaceImpl.new)
  end
end


class MyClass < TestSuperclass
  include Java::Override

  def method
    "MyClass: #{super}"
  end

  def my_long_method_name
    "MyClass: #{super}"
  end

  def my_long_method_name_with_abbrv
    "MyClass: #{super}"
  end

  def foo_bar?
    !super
  end

  def foo
    "MyClassGetter: #{super}"
  end

  def foo=(foo)
    super("MyClassSetter: #{foo}")
  end

  protected

  def protected_method
    "MyClass: #{super}"
  end

  private

  def my_private_method

  end
end

class MyInterfaceImpl
  include Java::Override
  include TestInterface

  def method
    "MyInterface#method"
  end

  def my_long_method_name_with_abbrv
    "MyInterface#my_long_method_name_with_abbrv"
  end
end
