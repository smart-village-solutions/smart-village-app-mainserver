# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/FilePath
# not only poll is checked here but every child model as well so we keep the file named survey_spec
RSpec.describe Survey::Poll, type: :model do
  describe "#destroy" do
    before do
      @survey = create(:survey)
      @question = @survey.questions.create
      @response_option = @question.response_options.create
    end

    context "with a vote_count" do
      before do
        @response_option.update(votes_count: 2)
      end

      it "is possible to delete poll, question and answer_options in one step" do
        result = @survey.destroy
        expect(result.destroyed?).to be true
        expect(@question.destroyed?).to be true
        expect(@response_option.destroyed?).to be true
      end

      it "is possible to delete a single answer_option" do
        result = @response_option.destroy
        expect(result.destroyed?).to be true
      end
    end

    context "without a vote_count" do
      it "is possible to delete poll, question and answer_options in one step" do
        result = @survey.destroy
        expect(result.destroyed?).to be true
        expect(@question.destroyed?).to be true
        expect(@response_option.destroyed?).to be true
      end

      it "is possible to delete a single answer_option" do
        result = @response_option.destroy
        expect(result.destroyed?).to be true
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
