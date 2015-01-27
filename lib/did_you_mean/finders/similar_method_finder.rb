module DidYouMean
  class SimilarMethodFinder < BaseFinder
    def initialize(exception)
      super
      @location     = exception.backtrace.first
      @method_names = MethodNameExtractor.new(receiver).method_names(name)
      @ivar_names   = SimilarNameFinder.new(frame_binding).ivar_names
    end

    def searches
      {method_name => @method_names, receiver_name => @ivar_names}
    end

    def receiver_name
      return unless receiver.nil?

      abs_path, lineno, label =
        /(.*):(.*):in `(.*)'/ =~ @location && [$1, $2.to_i, $3]

      line =
        case label
        when "irb_binding"
          Readline::HISTORY.to_a.last
        when "__pry__"
          Pry.history.to_a.last
        else
          File.open(abs_path) do |file|
            file.detect { file.lineno == lineno }
          end if File.exist?(abs_path)
        end

      (/@(\w+)["|'|)]*\.#{name}/ =~ line.to_s && $1).to_s
    end
  end

  case RUBY_ENGINE
  when 'ruby'
    require 'did_you_mean/method_receiver'
  when 'jruby'
    require 'did_you_mean/receiver_capturer'
    org.yukinishijima.ReceiverCapturer.setup(JRuby.runtime)
    NoMethodError.send(:attr, :receiver)
  when 'rbx'
    require 'did_you_mean/core_ext/rubinius'
    NoMethodError.send(:attr, :receiver)

    module SimilarMethodFinder::RubiniusSupport
      def self.new(exception)
        if exception.receiver === exception.frame_binding.eval("self")
          NameErrorFinders.new(exception)
        else
          SimilarMethodFinder.new(exception)
        end
      end
    end
  end
end
