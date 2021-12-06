# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::VotesForSurvey do
  def perform(**args)
    user = create(:user)
    user.app_role!
    user.save

    Mutations::VotesForSurvey.new(object: nil, context: { current_user: user }).resolve(args)
  end

  before do
    @survey = create(:survey)
    @question = @survey.questions.create
    @response_option_a = @question.response_options.create
    @response_option_b = @question.response_options.create
    @response_option_c = @question.response_options.create
  end

  it "increases one vote and decreases another" do
    perform(
      increase_id: @response_option_a.id,
      decrease_id: @response_option_b.id
    )
    @response_option_a.reload
    @response_option_b.reload

    expect(@response_option_a.votes_count).to eq(1)
    expect(@response_option_b.votes_count).to eq(-1)
  end

  it "increases two votes and decreases another" do
    perform(
      increase_id: [@response_option_a.id, @response_option_c.id],
      decrease_id: @response_option_b.id
    )
    @response_option_a.reload
    @response_option_b.reload
    @response_option_c.reload

    expect(@response_option_a.votes_count).to eq(1)
    expect(@response_option_b.votes_count).to eq(-1)
    expect(@response_option_c.votes_count).to eq(1)
  end

  it "increases one vote and decreases another two" do
    perform(
      increase_id: [@response_option_a.id],
      decrease_id: [@response_option_b.id, @response_option_c.id]
    )
    @response_option_a.reload
    @response_option_b.reload
    @response_option_c.reload

    expect(@response_option_a.votes_count).to eq(1)
    expect(@response_option_b.votes_count).to eq(-1)
    expect(@response_option_c.votes_count).to eq(-1)
  end

  it "increases one vote and decreases nothing" do
    perform(
      increase_id: @response_option_a.id
    )
    @response_option_a.reload
    @response_option_b.reload
    @response_option_c.reload

    expect(@response_option_a.votes_count).to eq(1)
    expect(@response_option_b.votes_count).to eq(0)
    expect(@response_option_c.votes_count).to eq(0)
  end
end
