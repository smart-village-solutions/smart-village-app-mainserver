# frozen_string_literal: true

# Controller Spec helpers to test our devise setup
module ControllerMacros
  def login_user(admin = false)
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = if admin
               FactoryBot.create(:admin)
             else
               FactoryBot.create(:user)
             end
      sign_in user
    end
  end

  def login_admin
    login_user(true)
  end

  def test_signed_out(http_method, action, params = {})
    context "when user is logged out" do
      before do
        if params[:create_model]
          entity = FactoryBot.create(params[:create_model])
          send(http_method, action, params: { id: entity.id })
        else
          send(http_method, action)
        end
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  def test_user_signed_in(http_method, action, params = {})
    context "when user is signed in" do
      login_user

      before do
        if params[:create_model]
          entity = FactoryBot.create(params[:create_model])
          send(http_method, action, params: { id: entity.id })
        else
          send(http_method, action)
        end
      end

      it { is_expected.to respond_with :not_found }
      it { expect(response.body).to include("not allowed") }
    end
  end
end
