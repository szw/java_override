# -*- encoding: utf-8 -*-
#
# Java::Override JRuby Module
# Copyright (c) 2012 Szymon Wrozynski
# Licensed under the MIT License conditions.
#
# Support for Java class inheritance in JRuby.
# Enable overriding plain Java methods with Ruby naming conventions.

require 'java/override/version'

module Java
  module Override

    private

    def method_added(m)
      return if @_java_override_internal_call
      @_java_override_internal_call = true

      unless private_instance_methods(true).include?(m)
        if m.to_s.end_with?('?')
          prefix = 'is'
        elsif m.to_s.end_with?('=')
          prefix = 'set'
        else
          prefix = 'get'
        end

        base = m.to_s.gsub(/[^a-z0-9]/i, '')

        find_java_m = ->(n) { superclass.instance_methods.find { |m| m.to_s.casecmp(n).zero? } }
        java_m = find_java_m.call("#{prefix}#{base}") || find_java_m.call(base)

        alias_method(java_m, m) if java_m && java_m != m
      end

      @_java_override_internal_call = false
    end

    def self.included(klass)
      klass.extend(self)
      klass.send(:undef_method, :method_added)
    end
  end
end
