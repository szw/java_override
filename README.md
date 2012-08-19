Java::Override JRuby Module
===========================

* [Homepage](https://rubygems.org/gems/java_override)
* [Documentation](https://github.com/szw/java_override/blob/master/README.md)

Description
-----------

Java::Override is a JRuby module that enables overriding native Java methods with Ruby
naming conventions. JRuby allows you to call Java methods (members of native Java
classes/interfaces) with Ruby naming style. Therefore you can use *snake_case* and
Ruby-like accessors instead of JavaBean ones.

In JRuby JavaBean accessors are *translated* to their Ruby counterparts (e.g.
<code>getFooBar</code> can be accessed via <code>foo\_bar</code>, <code>isFooBar</code>
via <code>foo\_bar?</code>, or <code>setFooBar</code> via <code>foo\_bar=</code>). Those
methods are added to Java classes as JRuby aliases.  However, if we want to override
a Java method we cannot define a Ruby-like method because JVM won't see it. JVM performs
polymorphic calls on its own, native methods.  And so we have to override native Java
methods and it doesn't look much pretty in JRuby code.

But the Java::Override module abolishes this inconvenience. Once included in the subclass
it creates aliases to native Java methods and supports inheritance and polymorphism that
way.  Moreover, it adds proper aliases for Java interfaces included as modules.

Examples
--------

Here is a good looking simple implementation of
<code>javax.swing.table.AbstractTableModel</code> class.

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

Java::Override requires JRuby in 1.9 mode and a decent JVM. It has been tested under
JRuby&nbsp;1.6.2 and Oracle Java&nbsp;7 JDK.

Install
-------

    $ gem install java_override

Copyright
---------

Copyright (c) 2012 Szymon Wrozynski

See LICENSE.txt for details.
