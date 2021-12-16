# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticContent, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:data_type) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  describe ".for_params" do

    let(:params) { {} }
    subject { StaticContent.for_params(params) }

    before do
      FactoryBot.create(:static_content, name: 'N', data_type: 'html')
      FactoryBot.create(:static_content, name: 'A', data_type: 'html')
      FactoryBot.create(:static_content, name: 'X', data_type: 'json')
      FactoryBot.create(:static_content, name: 'C', data_type: 'json')
    end

    context "without params" do
      it { is_expected.to eq(StaticContent.all) }
    end

    context "with type" do

      ['json', 'html'].each do |type|
        context type do
          let(:params) { { type: type } }

          it { expect(subject.count).to eq(2) }
          it { expect(subject).to eq(StaticContent.filter_by_type(type)) }
        end
      end
    end

    context "with name" do
      ['asc', 'desc'].each do |order|
        context order do
          let(:params) { { name: order } }

          it { expect(subject).to eq(StaticContent.ordered_by_name(order)) }
        end
      end
    end

    context "with id" do
      ['asc', 'desc'].each do |order|
        context order do
          let(:params) { { id: order } }

          it { expect(subject).to eq(StaticContent.ordered_by_id(order)) }
        end
      end
    end

    context "with type and" do
      let(:order) { 'desc' }
      let(:type) { 'html' }

      context "id" do
        let(:params) { { id: order, type: type } }
        it { expect(subject.count).to eq(2) }
        it { expect(subject).to eq(StaticContent.filter_by_type(type).ordered_by_id(order)) }
      end

      context "name" do
        let(:params) { { name: order, type: type } }
        it { expect(subject.count).to eq(2) }
        it { expect(subject).to eq(StaticContent.filter_by_type(type).ordered_by_name(order)) }
      end
    end
  end
end

# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
