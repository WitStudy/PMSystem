class AddNotNullToAuthorForArticle < ActiveRecord::Migration[5.1]
  def change
    change_column_null :articles, :author, false
  end
end
