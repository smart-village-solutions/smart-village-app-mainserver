# frozen_string_literal: true

require "rails_helper"

RSpec.describe Quota, type: :model do
  it { is_expected.to belong_to(:quotaable) }
  it { is_expected.to have_many(:redemptions) }
  it { is_expected.to allow_value(100).for(:max_quantity) }
  it { is_expected.to allow_value("once").for(:frequency) }
  it { is_expected.to allow_value(2).for(:max_per_person) }

  describe "#available_quantity_for_member" do
    let(:municipality) { create(:municipality) }
    let(:poi) { create(:point_of_interest) }
    let(:quota) { create(:quota, quotaable: poi ) }
    let(:member) { create(:member) }
    before { MunicipalityService.municipality_id = municipality.id }

    context "with no member and no redemption" do
      it "returns 100" do
        expect(quota.max_quantity).to eq(100)
        expect(quota.frequency).to eq("once")
        expect(quota.max_per_person).to eq(2)
      end
    end

    # 10 sind verfügbar, Max 2 Pro member und kein Member hat bisher verwendet
    context "with an member and no redemption" do
      it "returns 2" do
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.available_quantity).to eq(100)
        expect(member_availibiliity).to eq(2)
      end
    end

    # 10 sind verfügbar, Max 2 Pro member und Member hat 1 bisher verwendet
    context "with an member and 1 redemption" do
      it "returns 1" do
        redemption = create(:redemption, member: member, redemable: quota)
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.max_quantity).to eq(100)
        expect(quota.available_quantity).to eq(99)
        expect(member_availibiliity).to eq(1)
      end
    end

    # 1 ist verfügbar, Max 2 Pro member und Member hat 1 bisher verwendet => 0 ist verfügbar
    context "with an member and 1 redemption" do
      it "returns 1" do
        quota.max_quantity = 1
        create(:redemption, member: member, redemable: quota)
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.max_quantity).to eq(1)
        expect(quota.available_quantity).to eq(0)
        expect(member_availibiliity).to eq(0)
      end
    end

    # 2 ist verfügbar, Max 10 Pro member und Member hat 1 bisher verwendet => 1 ist verfügbar
    context "with an member and 1 redemption" do
      it "returns 1" do
        quota.max_quantity = 2
        quota.max_per_person = 10
        create(:redemption, member: member, redemable: quota)
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.max_quantity).to eq(2)
        expect(quota.max_per_person).to eq(10)
        expect(quota.available_quantity).to eq(1)
        expect(member_availibiliity).to eq(1)
      end
    end

    # 4 ist verfügbar, Max 10 Pro member und Member hat 1 bisher verwendet => 3 ist verfügbar
    context "with an member and 1 redemption" do
      it "returns 3" do
        quota.max_quantity = 4
        quota.max_per_person = 10
        create(:redemption, member: member, redemable: quota)
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.max_quantity).to eq(4)
        expect(quota.max_per_person).to eq(10)
        expect(quota.available_quantity).to eq(3)
        expect(member_availibiliity).to eq(3)
      end
    end

    # 4 ist verfügbar, Max 1 Pro member und Member A hat 1 bisher verwendet, Member B keinen => 1 ist verfügbar für Member B
    context "with an member and 1 redemption" do
      it "returns 1" do
        quota.max_quantity = 4
        quota.max_per_person = 1
        create(:redemption, member: member, redemable: quota)
        member_b = create(:member)
        member_availibiliity = quota.available_quantity_for_member(member_id: member_b.id)

        expect(quota.max_quantity).to eq(4)
        expect(quota.max_per_person).to eq(1)
        expect(quota.available_quantity).to eq(3)
        expect(member_availibiliity).to eq(1)
      end
    end

    # 4 ist verfügbar, unlimited max per member und Member A hat 1 bisher verwendet => 3 ist verfügbar
    context "with an member and 1 redemption" do
      it "returns 3" do
        quota.max_quantity = 4
        quota.max_per_person = nil
        create(:redemption, member: member, redemable: quota)
        member_availibiliity = quota.available_quantity_for_member(member_id: member.id)

        expect(quota.max_quantity).to eq(4)
        expect(quota.max_per_person).to eq(nil)
        expect(quota.available_quantity).to eq(3)
        expect(member_availibiliity).to eq(3)
      end
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  addition         :string(255)
#  city             :string(255)
#  street           :string(255)
#  zip              :string(255)
#  kind             :integer          default("default")
#  addressable_type :string(255)
#  addressable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
