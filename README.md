Java::Override JRuby Module
===========================

* [Homepage](https://rubygems.org/gems/java_override)
* [Documentation](http://rubydoc.info/gems/java_override/frames)

Description
-----------

Java::Override is a JRuby module enabling overriding native Java methods with
Ruby naming conventions. JRuby allows you to call Java methods (of Java classes/interfaces)
with Ruby conventions. You can use so called *snake_case*, Java Beans accessors are
*translated* to Ruby ones (e.g. <code>getFooBar</code> can be accessed via <code>foo\_bar</code>,
<code>isFooBar</code> via <code>foo\_bar?</code>, or <code>setFooBar</code> via <code>foo\_bar=</code>).
Those methods are added to Java classes as JRuby aliases. However, if you want to override
a Java method you cannot override such alias because Java will not see it. Java will do polymorphic
call of its own, native methods. Therefore you have to override native Java methods and it
doesn't look pretty in JRuby code.

The Java::Override module abolishes this inconvenience. Once included in the subclass it
creates aliases to native java methods and supports inheritance and polymorphism that way.
Moreover, it adds proper aliases for Java interfaces included as modules.

Examples
--------

Look at the following implementation of javax.swing.table.AbstractTableModel class.

    require 'java/override'

    java_import javax::swing::table::AbstractTableModel

    class MyTableModel < AbstractTableModel
      include Java::Override

      def initialize
        super
        @column_names = ['First Name', 'Last Name']
        @data = [
          ['John', 'Doe'],
          ['Jack', 'FooBar']
        ]
      end

      def column_count
        @column_names.size
      end

      def row_count
        @data.size
      end

      def column_name(col)
        @column_names[col]
      end

      def get_value_at(row, col)
        @data[row][col]
      end

      def column_class(col)
        get_value_at(0, c).java_class
      end

      def cell_editable?(row, col)
        col.zero?
      end

      def set_value_at(value, row, col)
        @data[row][col] = value
        fire_table_cell_updated(row, col)
      end
    end

Requirements
------------

Java::Override requires JRuby in 1.9 mode and a decent JVM. It has been tested
under JRuby 1.6.2 and Oracle Java 7 JDK.

Install
-------

    $ gem install java_override

Copyright
---------

Copyright (c) 2012 Szymon Wrozynski

See LICENSE.txt for details.
