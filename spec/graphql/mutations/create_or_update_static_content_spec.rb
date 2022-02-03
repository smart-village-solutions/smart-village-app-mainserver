# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateOrUpdateStaticContent do
  def perform(**args)
    user = User.find_by(email: "admin@smart-village.app") || create(:admin)
    user.save

    Mutations::CreateOrUpdateStaticContent.new(
      object: nil,
      context: { current_user: user }
    ).resolve(args)
  end

  describe "creation of a html static content" do
    let(:static_content) do
      perform(
        name: "asd",
        content: "<p>asdasd asd dasd asdwewe</p>",
        data_type: "html"
      )
    end

    it "creates a new and valid static content" do
      expect(static_content).to be_a(StaticContent)
      expect(static_content).to be_valid
    end

    it "has a name" do
      expect(static_content.name).to eq("asd")
    end

    it "has a html content" do
      expect(static_content.content).to eq("<p>asdasd asd dasd asdwewe</p>")
    end

    it "has a html data type" do
      expect(static_content.data_type).to eq("html")
    end

    it "fails creating with same name again" do
      static_content
      new_static_content = perform(
        name: "asd",
        content: "<p>bbb asd dasd asdwewe</p>",
        data_type: "html"
      )

      expect(new_static_content).to be_a(GraphQL::ExecutionError)
      expect(new_static_content.message).to eq("Invalid input: Name has already been taken")
    end

    it "creates a new and valid static content with same name and new version" do
      static_content
      new_static_content = perform(
        name: "asd",
        content: "<p>bbb asd dasd asdwewe</p>",
        version: "1.0.0",
        data_type: "html"
      )

      expect(new_static_content).to be_a(StaticContent)
      expect(new_static_content).to be_valid
    end

    it "fails creating without data type" do
      static_content
      new_static_content = perform(
        name: "asdääasd",
        content: "<p>böäöäöäbb asd dasd asdwewe</p>"
      )

      expect(new_static_content).to be_a(GraphQL::ExecutionError)
      expect(new_static_content.message).to eq("Invalid input: Data type can't be blank")
    end
  end

  describe "update of a html static content" do
    let(:static_content) do
      perform(
        name: "asd",
        content: "<p>asdasd asd dasd asdwewe</p>",
        data_type: "html"
      )
    end

    let(:updated_static_content) do
      perform(
        id: static_content.id,
        name: "bhgs",
        content: "<p>bhgsss bbbbaaaasd bdasd bdwewe</p>"
      )
    end

    let(:updated_static_content_with_bad_name) do
      perform(
        id: static_content.id,
        name: "Umlauts are grät and ßüpernice!"
      )
    end

    it "stays a valid static content" do
      expect(updated_static_content).to be_a(StaticContent)
      expect(updated_static_content).to be_valid
    end

    it "has a new name" do
      expect(updated_static_content.name).to eq("bhgs")
    end

    it "has a new html content" do
      expect(updated_static_content.content).to eq("<p>bhgsss bbbbaaaasd bdasd bdwewe</p>")
    end

    it "stays the html data type" do
      expect(updated_static_content.data_type).to eq("html")
    end
  end

  describe "creation of a html static content with bad name" do
    let(:static_content) do
      perform(
        name: "Umlauts are grät and ßüpernice!",
        content: "<p>asdasd asd dasd asdwewe</p>",
        data_type: "html"
      )
    end

    it "creates a new and valid static content" do
      expect(static_content).to be_a(StaticContent)
      expect(static_content).to be_valid
    end

    it "has a new name" do
      expect(static_content.name).to eq("umlauts-are-graet-and-ssuepernice")
    end

    it "has a new html content" do
      expect(static_content.content).to eq("<p>asdasd asd dasd asdwewe</p>")
    end

    it "stays the html data type" do
      expect(static_content.data_type).to eq("html")
    end
  end
end
