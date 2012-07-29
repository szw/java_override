require 'helper'
require 'java_superclass'

class TestJavaSuperclass < Test::Unit::TestCase

  def test_version
    version = JavaSuperclass.const_get('VERSION')

    assert !version.empty?, 'should have a VERSION constant'
  end

end
