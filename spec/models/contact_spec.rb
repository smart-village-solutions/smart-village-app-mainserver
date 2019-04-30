# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contact, type: :model do
  it { is_expected.to belong_to(:contactable) }
  it { is_expected.to have_one(:web_url) }

  describe "#email" do
    let(:valid_contact) { create :contact }

    context "with valid emails" do
      it "marks the record as valid" do
        expect(valid_contact).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  email            :string(255)
#  contactable_type :string(255)
#  contactable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
