# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contact, type: :model do
  it { is_expected.to belong_to(:contactable) }
  it { is_expected.to have_many(:web_urls) }

  describe "#email" do
    let(:valid_contact) { create(:contact, :for_operating_company) }
    let(:invalid_contact) { build(:contact, :for_operating_company, email: "test") }
    let(:blank_email_contact) { build(:contact, :for_operating_company, email: "") }

    context "with a valid email" do
      it "marks the record as valid" do
        expect(valid_contact).to be_valid
      end
    end

    context "with an invalid email" do
      it "marks the record as invalid" do
        expect(invalid_contact).to be_invalid
      end
    end

    context "with an blank email" do
      it "marks the record as valid" do
        expect(blank_email_contact).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
