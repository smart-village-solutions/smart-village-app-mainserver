require 'rails_helper'

RSpec.describe FixedDate, type: :model do
  it { is_expected.to belong_to(:dateable) }
end
