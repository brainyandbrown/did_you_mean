module DidYouMean
  class SimilarClassFinder < BaseFinder
    def initialize(*)
      super
      @class_name    = name || (/([A-Z]\w*$)/ =~ org_message && $1)
      @constan_names = MessageExtractor.new(org_message).constant_names
    end

    def suggestions
      super.map(&:full_name)
    end

    def searches
      {@class_name => @constant_names}
    end
  end
end
