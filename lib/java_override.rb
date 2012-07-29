# -*- encoding: utf-8 -*-
#
# JavaOverride JRuby Module
# Copyright (c) 2012 Szymon Wrozynski
# Licensed under the MIT License conditions.
#
# Support for Java class inheritance in JRuby.
# Enable overriding plain Java methods with Ruby naming conventions.

require 'java_override/version'

module JavaOverride

  def method_added(m)
    return if @_java_override_internal__call
    @_java_override_internal__call = true

    return if private_instance_methods(true).include?(m)

    new_m = m.to_s.split(/[^a-z0-9]/i).map { |w| w.capitalize }.join

    return if new_m.empty?

    if m.to_s.end_with?('?') && superclass.instance_methods.include?("is#{new_m}".to_sym)
      alias_method("is#{new_m}", m)
    elsif m.to_s.end_with?('=') && superclass.instance_methods.include?("set#{new_m}".to_sym)
      alias_method("set#{new_m}", m)
    elsif superclass.instance_methods.include?("get#{new_m}".to_sym)
      alias_method("get#{new_m}", m)
    else
      new_m = new_m[0, 1].downcase + new_m[1..-1]

      if superclass.instance_methods.include?(new_m.to_sym)
        alias_method(new_m, m)
      end
    end

    @_java_override_internal__call = false
  end

  def self.included(klass)
    klass.extend(self)
    klass.send(:undef_method, :method_added)
  end
end
