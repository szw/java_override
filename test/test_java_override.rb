require 'helper'
require 'java'
require 'java_override'
require 'shoulda'

java_import javax::swing::JPanel

class TestJavaOverride < Test::Unit::TestCase
  def setup
    @j_panel = JPanel.new
    @my_panel = MyPanel.new
  end

  should "have version" do
    version = JavaOverride.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

  should "override simple methods" do
    assert_equal "MyPanel", @my_panel.fire_property_change('a', 'b', 'c')
    assert_equal "MyPanel", @my_panel.firePropertyChange('a', 'b', 'c')
  end

  should "override javabean accessors" do
    @my_panel.name = 'foo'

    assert_equal "MyPanel: foobar", @my_panel.name
    assert_equal "MyPanel: foobar", @my_panel.getName
    assert_equal "MyPanel: #{@j_panel.minimum_size_set?}", @my_panel.isMinimumSizeSet
    assert_equal "MyPanel: #{@j_panel.isMinimumSizeSet}", @my_panel.minimum_size_set?
  end

  should "not add aliases for private methods" do
    assert MyPanel.private_instance_methods(true).include?(:print_all)
    assert MyPanel.private_instance_methods(true).include?(:paint_children)
    refute MyPanel.private_instance_methods(true).include?(:printAll)
    refute MyPanel.private_instance_methods(true).include?(:paintChildren)
    refute MyPanel.instance_methods(false).include?(:printAll)
    refute MyPanel.instance_methods(false).include?(:paintChildren)
  end

  should "add method_added only to singleton class even if included" do
    refute_respond_to @my_panel, :method_added
    refute MyPanel.instance_methods.include?(:method_added)
  end
end

class MyPanel < JPanel
  include JavaOverride

  def fire_property_change(property_name, old_value, new_value)
    super(property_name, old_value, new_value)
    "MyPanel"
  end

  def name=(value)
    super "MyPanel: #{value}"
  end

  def name
    "#{super}bar"
  end

  def minimum_size_set?
    "MyPanel: #{super}"
  end

  private

  def print_all
  end

  def paint_children
  end
end
