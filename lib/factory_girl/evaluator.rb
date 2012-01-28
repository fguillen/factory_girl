require "active_support/core_ext/class/attribute"

module FactoryGirl
  class Evaluator < ActiveSupport::BasicObject
    @@callbacks = []
    @@attribute_lists = []

    def self.callbacks
      @@callbacks
    end

    def self.callbacks=(value)
      @@callbacks = value
    end

    def self.attribute_lists
      @@attribute_lists
    end

    def self.attribute_lists=(value)
      @@attribute_lists = value
    end

    def callbacks
      @@callbacks
    end

    def attribute_lists
      @@attribute_lists
    end

    def attribute_list
      AttributeList.new.tap do |list|
        attribute_lists.each do |attribute_list|
          list.apply_attributes attribute_list.to_a
        end
      end
    end
    undef_method(:id) if method_defined?(:id)

    def initialize(build_strategy, overrides = {})
      @build_strategy    = build_strategy
      @overrides         = overrides
      @cached_attributes = overrides

      @build_strategy.add_observer(CallbackRunner.new(self.callbacks, self))
    end

    delegate :association, :to => :@build_strategy

    def instance=(object_instance)
      @instance = object_instance
    end

    def method_missing(method_name, *args, &block)
      if @cached_attributes.key?(method_name)
        @cached_attributes[method_name]
      else
        @instance.send(method_name, *args, &block)
      end
    end

    def __overrides
      @overrides
    end

    private

    class CallbackRunner
      def initialize(callbacks, evaluator)
        @callbacks = callbacks
        @evaluator = evaluator
      end

      def update(name, result_instance)
        @callbacks.select {|callback| callback.name == name }.each do |callback|
          callback.run(result_instance, @evaluator)
        end
      end
    end
  end
end
