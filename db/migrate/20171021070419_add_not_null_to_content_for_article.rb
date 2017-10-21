class AddNotNullToContentForArticle < ActiveRecord::Migration[5.1]
  def change
    change_column_null :articles, :content, false
  end
end
