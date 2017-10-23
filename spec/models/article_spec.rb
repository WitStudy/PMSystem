require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validation' do
    presence_columns = %i[title content author]
    presence_columns.each do |column|
      it { should validate_presence_of column }
    end

    var_char_length = ApplicationRecord::MAX_VAR_CHAR
    var_char_columns = %i[title content author]
    var_char_columns.each do |column|
      it { should validate_length_of(column).is_at_most(var_char_length) }
    end
  end
end
