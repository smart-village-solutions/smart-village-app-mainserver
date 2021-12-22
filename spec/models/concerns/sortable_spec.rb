require 'rails_helper'

RSpec.describe Sortable do

  fields = [:email, :role]

  let(:params) { {} }
  let(:dummy_class) { class_for_fields(*fields) }

  it "should add sorting class methods for specified fields" do
    dummy_class1 = class_for_fields(:email) 
    dummy_class2 = class_for_fields(:role) 
    dummy_class3 = class_for_fields(:email, :role) 

    expect(dummy_class1).to respond_to(:sorted_by_email)
    expect(dummy_class2).to respond_to(:sorted_by_role)
    expect(dummy_class3).to respond_to(:sorted_by_email)
    expect(dummy_class3).to respond_to(:sorted_by_role)
  end

  describe ".sorted_for_params" do

    subject { dummy_class.sorted_for_params(params) }

    before do
      dummy_class.create(email: 'bernd@hotmail.de', role: 0)
      dummy_class.create(email: 'sophie@web.de', role: 3)
      dummy_class.create(email: 'peter@gmail.com', role: 2)
      dummy_class.create(email: 'juergen@gmx.net', role: 0)
      dummy_class.create(email: 'achim@protonmail.com', role: 1)
    end

    context "without params" do
      it { is_expected.to eq(dummy_class.all) }
    end

    fields.each do |field|
      context "with sort_column: #{field} and" do

        ['asc', 'desc'].each do |order|
          context "sort_oder: #{order}" do
            let(:params) { { sort_column: field, sort_order: order } }
            it { expect(subject).to eq(dummy_class.send("sorted_by_#{field}", order)) }
          end
        end

      end
    end

  end

  describe ".params_for_link" do

    subject { Sortable.params_for_link(params, sort_column) }

    context "without sort_column" do

      let(:sort_column) { nil }

      it { is_expected.to eq(params) }
    end

    context "with sort_column" do

      let(:sort_column) { 'email' }

      context "and no sort_order" do
        default_sort_order = 'asc'

        it "should default sort_order to #{default_sort_order}" do
          is_expected.to eq({
            sort_column: sort_column,
            sort_order: default_sort_order
          })
        end
      end

      context "sort_column changes" do
        let(:params) { { sort_column: 'role', sort_order: 'asc' } }

        it "should change sort_column and reverse sort_order" do
          is_expected.to eq({
            sort_column: sort_column,
            sort_order: 'desc'
          })
        end
      end


      context "same sort_column" do
        let(:params) { { sort_column: sort_column, sort_order: 'asc' } }

        it "should keep sort_column and reverse sort_order" do
          is_expected.to eq({
            sort_column: sort_column,
            sort_order: 'desc'
          })
        end
      end
    end
  end
end

def class_for_fields(*fields)
  Class.new(ActiveRecord::Base) do
    self.table_name = 'users'

    include Sortable.new *fields
  end
end
