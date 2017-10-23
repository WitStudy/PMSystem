# 記事モデル
class Article < ApplicationRecord
  validates :title,   presence: true, length: { maximum: MAX_VAR_CHAR }
  validates :content, presence: true, length: { maximum: MAX_VAR_CHAR }
  validates :author,  presence: true, length: { maximum: MAX_VAR_CHAR }
end
