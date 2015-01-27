module DidYouMean
  class SimilarNameFinder < BaseFinder
    def initialize(exception)
      super
      extractor     = BindingExtractor.new(frame_binding)
      @lvar_names   = extractor.lvar_names
      @ivar_names   = extractor.ivar_names
      @method_names = MethodNameExtractor.new(frame_binding.eval('self')).method_names
    end

    def searches
      {name => (@lvar_names + @method_names + @ivar_names)}
    end
  end
end
