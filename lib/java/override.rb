# -*- encoding: utf-8 -*-
#
# Java::Override JRuby Module
# Copyright (c) 2012 - 2013 Szymon Wrozynski
# Licensed under the MIT License conditions.
#
# Support for Java class inheritance in JRuby.
# Enable overriding plain Java methods with Ruby naming conventions.

require 'java'
require 'set'
require 'java/override/version'

module Java
  module Override

    private

    def method_added(method)
      return if @_java_override_internal_call

      @_java_override_internal_call = true

      unless private_instance_methods(true).include?(method)
        if method.to_s.end_with?('?')
          prefix = 'is'
        elsif method.to_s.end_with?('=')
          prefix = 'set'
        else
          prefix = 'get'
        end

        basename = method.to_s.gsub(/[^a-z0-9]/i, '')
        super_method = find_super_method("#{prefix}#{basename}") || find_super_method(basename)
        alias_method(super_method, method) if super_method && super_method != method.to_s
      end

      remove_instance_variable(:@_java_override_internal_call)
    end

    def find_super_method(name)
      unless @_java_override_super_methods
        @_java_override_super_methods = Set.new(superclass.instance_methods.map(&:to_s))

        included_modules.each do |included_module|
          @_java_override_super_methods.merge(included_module.java_class.java_instance_methods.map(&:name).uniq) if included_module.respond_to?(:java_class)
        end
      end

      @_java_override_super_methods.find { |super_method| super_method.to_s.casecmp(name).zero? }
    end

    def self.included(klass)
      klass.extend(self)
      klass.send(:undef_method, :method_added, :find_super_method)
    end
  end
end
