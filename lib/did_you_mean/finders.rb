require "did_you_mean/names"
require "did_you_mean/word_collection"

module DidYouMean
  class BaseFinder
    AT    = "@".freeze
    EMPTY = "".freeze

    attr :org_message, :name, :frame_binding, :receiver

    def initialize(exception)
      @org_message   = exception.original_message
      @name          = exception.name          if exception.respond_to?(:name)
      @frame_binding = exception.frame_binding if exception.respond_to?(:frame_binding)
      @receiver      = exception.receiver      if exception.respond_to?(:receievr)
    end

    def suggestions
      @suggestions ||= searches.flat_map {|_, __| WordCollection.new(__).similar_to(_) }
    end

    class MessageExtractor < Struct.new(:message)
      def constant_names
        scopes.flat_map do |scope|
          scope.constants.map do |c|
            ClassName.new(c.to_s, scope == Object ? EMPTY : "#{scope}::")
          end
        end
      end

      def scopes
        scope_base.inject([Object]) do |_scopes, scope|
          _scopes << _scopes.last.const_get(scope)
        end
      end

      def scope_base
        (/(([A-Z]\w*::)*)([A-Z]\w*)$/ =~ message ? $1 : EMPTY).split("::")
      end
    end

    class MethodNameExtractor < Struct.new(:obj)
      def method_names(excluded = nil)
        names = obj.methods + obj.singleton_methods
        names.delete(excluded)
        names.uniq.map {|name| MethodName.new(name.to_s) }
      end
    end

    class BindingExtractor < Struct.new(:frame_binding)
      def lvar_names
        frame_binding.eval("local_variables").map(&:to_s)
      end

      def ivar_names
        frame_binding.eval("instance_variables").map {|n| IvarName.new(n.to_s.tr(AT, EMPTY)) }
      end

      def column_names
        frame_binding.eval("self.class").columns.map {|c| ColumnName.new(c.name, c.type) }
      end
    end
  end

  class NullFinder
    def initialize(*);  end
    def suggestions; [] end
  end
end

require 'did_you_mean/finders/name_error_finders'
require 'did_you_mean/finders/similar_attribute_finder'
require 'did_you_mean/finders/similar_method_finder'
