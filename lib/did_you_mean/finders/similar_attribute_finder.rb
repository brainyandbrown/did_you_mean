module DidYouMean
  class SimilarAttributeFinder < BaseFinder
    def initialize(*)
      super
      @attr_name    = (/unknown attribute(: | ')(\w+)/ =~ org_message && $2)
      @column_names = BindingExtractor.new(frame_binding).column_names
    end

    def searches
      {@attr_name => @column_names}
    end
  end
end
