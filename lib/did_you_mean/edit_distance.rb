module DidYouMean
  module Jaro
    module_function

    def distance(str1, str2)
      str1, str2 = str2, str1 if str1.length > str2.length
      length1, length2 = str1.length, str2.length

      m          = 0.0
      t          = 0.0
      range      = (length2 / 2).floor - 1
      flags1     = 0
      flags2     = 0

      # Avoid duplicating enumerable objects
      # Also, call #to_a since #codepoints returns an Enumerator on Ruby 1.9.3.
      str1_codepoints = str1.codepoints.to_a
      str2_codepoints = str2.codepoints.to_a

      i = 0
      while i < length1
        last = i + range
        j    = (i >= range) ? i - range : 0

        while j <= last
          if flags2[j] == 0 && str1_codepoints[i] == str2_codepoints[j]
            flags2 |= (1 << j)
            flags1 |= (1 << i)
            m += 1
            break
          end

          j += 1
        end

        i += 1
      end

      k = i = 0
      while i < length1
        if flags1[i] != 0
          j = index = k

          k = while j < length2
            index = j
            break(j + 1) if flags2[j] != 0

            j += 1
          end

          t += 1 if str1_codepoints[i] != str2_codepoints[index]
        end

        i += 1
      end
      t = (t / 2).floor

      m == 0 ? 0 : (m / length1 + m / length2 + (m - t) / m) / 3
    end
  end

  module JaroNishijima
    module_function

    def distance(str1, str2)
      length1, length2 = str1.length, str2.length
      length1, length2 = length2, length1 if length1 > length2

      jaro_distance = Jaro.distance(str1, str2)
      jaro_distance == 0 ? 0 : ((jaro_distance * 3) + (length1.to_f / length2)) / 4.0
    end
  end

  module JaroWinkler
    WEIGHT    = 0.1
    THRESHOLD = 0.7

    module_function

    def distance(str1, str2)
      jaro_distance = Jaro.distance(str1, str2)

      if jaro_distance > THRESHOLD
        jaro_distance + (prefix_bonus(str1, str2) * WEIGHT * (1 - jaro_distance))
      else
        jaro_distance
      end
    end

    def prefix_bonus(str1, str2)
      codepoints2 = str2.codepoints.to_a
      result      = 0

      i = 0
      str1.each_codepoint do |char1|
        char1 == codepoints2[i] && i < 4 ? result += 1 : break
        i += 1
      end

      result
    end
  end

  module JaroNishijimaWinkler
    WEIGHT    = 0.06
    THRESHOLD = 0.7

    module_function

    def distance(str1, str2)
      _distance = JaroNishijima.distance(str1, str2)

      if _distance > THRESHOLD
        _distance + (JaroWinkler.prefix_bonus(str1, str2) * WEIGHT * (1 - _distance))
      else
        _distance
      end
    end
  end

  module Levenshtein # :nodoc:
    module_function

    # This code is based directly on the Text gem implementation
    # Returns a value representing the "cost" of transforming str1 into str2
    def distance(str1, str2)
      n = str1.length
      m = str2.length
      return m if n.zero?
      return n if m.zero?

      d = (0..m).to_a
      x = nil

      # to avoid duplicating an enumerable object, create it outside of the loop
      str2_codepoint_enumerable = str2.each_codepoint

      str1.each_codepoint.with_index(1) do |char1, i|
        str2_codepoint_enumerable.with_index do |char2, j|
          cost = (char1 == char2) ? 0 : 1
          x = min3(
            d[j+1] + 1, # insertion
            i + 1,      # deletion
            d[j] + cost # substitution
          )
          d[j] = i
          i = x
        end
        d[m] = x
      end

      x
    end

    # detects the minimum value out of three arguments. This method is
    # faster than `[a, b, c].min` and puts less GC pressure.
    # See https://github.com/yuki24/did_you_mean/pull/1 for a performance
    # benchmark.
    def min3(a, b, c)
      if a < b && a < c
        a
      elsif b < c
        b
      else
        c
      end
    end
  end
end