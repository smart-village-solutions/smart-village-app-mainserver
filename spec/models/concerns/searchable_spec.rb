require 'rails_helper'

RSpec.describe Searchable do

  search_columns = [:data_type, :name]
  let(:dummy_class) { class_for_search_columns(*search_columns) }

  context "with searchable_on called" do
    it "should add searching class methods for specified search_columns" do
      dummy_class1 = class_for_search_columns(:name) 
      dummy_class2 = class_for_search_columns(:type) 
      dummy_class3 = class_for_search_columns(:name, :type) 

      expect(dummy_class1).to respond_to(:where_name_contains)
      expect(dummy_class2).to respond_to(:where_type_contains)
      expect(dummy_class3).to respond_to(:where_name_contains)
      expect(dummy_class3).to respond_to(:where_type_contains)
    end
  end


  search_columns.each do |search_column|
    describe ".where_#{search_column}_contains" do

      let(:search_string) { 'o' }
      subject { dummy_class.send("where_#{search_column}_contains", search_string) }

      before do
        dummy_class.create(name: 'Hallo', data_type: 'json')
        dummy_class.create(name: 'Hallo2', data_type: 'json')
        dummy_class.create(name: 'Ciao', data_type: 'html')
        dummy_class.create(name: 'Tschüss', data_type: 'html')
        dummy_class.create(name: 'Whatever', data_type: 'html')
      end

      context 'without search_string given' do
        let(:search_string) { '' }
        it { is_expected.to eq(dummy_class.all) }
      end

      context 'without search_string given' do
        let(:search_string) { 'o' }
        it { is_expected.to eq(dummy_class.where("#{search_column} LIKE '%#{search_string}%'")) }
      end

    end
  end
end

def class_for_search_columns(*search_columns)
  Class.new(ActiveRecord::Base) do
    self.table_name = 'static_contents'

    include Searchable
    searchable_on *search_columns
  end
end
