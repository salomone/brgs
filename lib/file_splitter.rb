# -*- coding: utf-8 -*-

class FileSplitter
  class << self
    def segment(filename)
      lc = count(filename)
      cl = 0
      step = [lc, lines_limit()].min
      segments = []
      while cl < lc
        first = cl
        cl = cl + step
        last = [lc - 1, cl - 1].min
        segments.push({first: first + 1, last: last + 1})
      end
      return segments
    end

    def lines_limit
      100000
    end

    def count(filename)
      if empty?(filename)
          return 0
      end
      lc = `wc -l #{filename}`.match(/(\d+)/)[1].to_i
      lc = lc + 1 unless ends_with_newline?(filename)
      return lc
    end

    def ends_with_newline?(filename)
      `tail -n 1 #{filename} | wc -l`.match(/(\d+)/)[1].to_i == 1
    end

    def empty?(filename)
      `wc -w #{filename}`.match(/(\d+)/)[1].to_i == 0
    end

    def piece(filename, segment)
      return `sed -n #{segment[:first]},#{segment[:last]}p #{filename}`
    end
  end
end
