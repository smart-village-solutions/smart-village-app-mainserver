# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticContentsController, type: :controller do
  let(:static_content) { FactoryBot.create(:static_content) }

  describe "GET #index" do
    test_signed_out(:get, :index)
    test_user_signed_in(:get, :index)

    context "when admin is signed in" do
      login_admin
      render_views

      it "returns a success response" do
        get :index, params: {}
        expect(response.status).to eq(200)
      end

      it "includes static contents" do
        name1 = "StaticContentABC"
        name2 = "StaticContentXYZ"
        FactoryBot.create(:static_content, name: name1)
        FactoryBot.create(:static_content, name: name2)
        get :index, params: {}

        expect(response.body).to include(name1)
        expect(response.body).to include(name2)
      end
    end
  end

  describe "GET #show" do
    test_signed_out(:get, :show, create_model: :static_content)
    test_user_signed_in(:get, :show, create_model: :static_content)

    context "when admin is signed in" do
      login_admin
      render_views

      it "returns a success response" do
        get :show, params: { id: static_content.id }
        expect(response).to be_successful
      end

      it "shows name of static content" do
        get :show, params: { id: static_content.id }
        expect(response.body).to include(static_content.name)
      end
    end
  end

  describe "GET #new" do
    test_signed_out(:get, :new)
    test_user_signed_in(:get, :new)

    context "when admin is signed in" do
      login_admin

      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    let(:static_content) { FactoryBot.create(:static_content) }

    test_signed_out(:get, :edit, create_model: :static_content)
    test_user_signed_in(:get, :edit, create_model: :static_content)

    context "when admin is signed in" do
      login_admin
      render_views

      it "returns a success response" do
        get :edit, params: { id: static_content.id }
        expect(response).to be_successful
      end

      it "shows name of static content" do
        get :show, params: { id: static_content.id }
        expect(response.body).to include(static_content.name)
      end
    end
  end

  describe "POST #create" do
    test_signed_out(:post, :create)
    test_user_signed_in(:post, :create)

    context "when admin is signed in" do
      login_admin

      context "with valid params" do
        it "creates a new StaticContent" do
          expect do
            post :create, params: { static_content: FactoryBot.attributes_for(:static_content) }
          end.to change(StaticContent, :count).by(1)
        end

        it "redirects to the created static_content" do
          post :create, params: { static_content: FactoryBot.attributes_for(:static_content) }
          expect(response).to redirect_to(StaticContent.last)
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) { { name: "" } }

        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { static_content: invalid_attributes }
          expect(response).to be_successful
        end

        # TODO: Maybe unnecessary
        it "does not create a new StaticContent" do
          expect do
            post :create, params: { static_content: invalid_attributes }
          end.to change(StaticContent, :count).by(0)
        end
      end
    end
  end

  describe "PUT #update" do
    test_signed_out(:put, :update, create_model: :static_content)
    test_user_signed_in(:put, :update, create_model: :static_content)

    context "when admin is signed in" do
      login_admin

      context "with valid params" do
        let(:valid_attributes) { { name: "New Name" } }

        it "updates the requested static_content" do
          put :update, params: { id: static_content.id, static_content: valid_attributes }
          static_content.reload
          expect(static_content.name).to eq(valid_attributes[:name])
        end

        it "redirects to the static_content" do
          put :update, params: { id: static_content.id, static_content: valid_attributes }
          expect(response).to redirect_to(static_content)
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) { { name: "" } }

        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: static_content.to_param, static_content: invalid_attributes }
          expect(response).to be_successful
        end

        # TODO: Maybe unnecessary
        it "does not update the requested static_content" do
          put :update, params: { id: static_content.id, static_content: invalid_attributes }
          static_content.reload
          expect(static_content.name).not_to eq(invalid_attributes[:name])
        end
      end
    end
  end

  describe "DELETE #destroy" do
    test_signed_out(:delete, :destroy, create_model: :static_content)
    test_user_signed_in(:delete, :destroy, create_model: :static_content)

    context "when admin is signed in" do
      login_admin

      it "destroys the requested static_content" do
        sc = FactoryBot.create(:static_content)
        expect do
          delete :destroy, params: { id: sc.id }
        end.to change(StaticContent, :count).by(-1)
      end

      it "redirects to the static_contents list" do
        delete :destroy, params: { id: static_content.id }
        expect(response).to redirect_to(static_contents_url)
      end
    end
  end
end
