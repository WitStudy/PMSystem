# 基底モデル
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  MAX_VAR_CHAR = 255
end
