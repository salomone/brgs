# -*- coding: utf-8 -*-

class FileSplitter
  class << self
    def split(rdf)
      lc = count(rdf)
      cl = 0
      step = [lc, lines_limit()].min
      segments = []
      while cl < lc
        first = cl
        cl = cl + step
        last = [lc - 1, cl - 1].min
        segments.push({first: first, last: last})
      end
      return segments
    end

    def lines_limit
      1000000
    end

    def count(rdf)
      if empty?(rdf)
          return 0
      end
      lc = `wc -l #{rdf}`.match(/(\d+)/)[1].to_i
      lc = lc + 1 unless ends_with_newline?(rdf)
      return lc
    end

    def ends_with_newline?(rdf)
      `tail -n 1 #{rdf} | wc -l`.match(/(\d+)/)[1].to_i == 1
    end

    def empty?(rdf)
      `wc -w #{rdf}`.match(/(\d+)/)[1].to_i == 0
    end

  end
end
