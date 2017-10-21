require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validation' do
    presence_columns = %i[title content author]
    presence_columns.each do |column|
      it { should validate_presence_of column }
    end
  end
end
