# -*- coding: utf-8 -*-
class MatrixBuilder
  extend Resque::Plugins::JobStats
  @queue = :matrix_builder

  def self.perform(name, path_index)
    BRGS::Builder.build path_index
  end
end
