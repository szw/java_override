# -*- encoding: utf-8 -*-
#
# Java::Override JRuby Module
# Copyright (c) 2012 Szymon Wrozynski
# Licensed under the MIT License conditions.
#
# Useful utilities supporting Java class inheritance in JRuby.
# Enable overriding plain Java methods with Ruby naming conventions.

require 'java/override/version'

module Java
  module Override

    def method_added(m)
      return if @_java_override_hook_recursion_call
      @_java_override_hook_recursion_call = true

      new_m = m.to_s.split(/[^a-z0-9]/i).map { |w| w.capitalize }.join

      return if new_m.empty?

      super_methods = self.superclass.public_instance_methods +
                      self.superclass.protected_instance_methods

      if m.to_s.end_with?('?') && super_methods.include?("is#{new_m}".to_sym)
        self.send(:alias_method, "is#{new_m}", m)
      elsif m.to_s.end_with?('=') && super_methods.include?("set#{new_m}".to_sym)
        self.send(:alias_method, "set#{new_m}", m)
      elsif super_methods.include?("get#{new_m}".to_sym)
        self.send(:alias_method, "get#{new_m}", m)
      else
        new_m_lowercase = new_m[0, 1].downcase + new_m[1..-1]

        if super_methods.include?(new_m_lowercase.to_sym)
          self.send(:alias_method, new_m_lowercase, m)
        end
      end
    ensure
      @_java_override_hook_recursion_call = false
    end

    def self.included(klass)
      klass.extend(self)
    end
  end
end
