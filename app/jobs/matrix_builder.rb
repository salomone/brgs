# -*- coding: utf-8 -*-
class MatrixBuilder
  @queue = :matrix_builder

  def self.perform(name, path_index)
    BRGS::Builder.build path_index
  end
end
