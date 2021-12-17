module ControllerMacros
  def login_user(admin=false)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      if admin
        user = FactoryBot.create(:admin)
      else
        user = FactoryBot.create(:user)
      end
      sign_in user
    end
  end

	def login_admin
		login_user(true)
	end

  def test_signed_out(http_method, action, params={})
    context "when user is logged out" do
      before do
        if params[:create_model]
          entity = FactoryBot.create(params[:create_model])
          self.send(http_method, action, params: { id: entity.id })
        else
          self.send(http_method, action)
        end
      end

      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  def test_user_signed_in(http_method, action, params={})
    context "when user is signed in" do
      login_user

      before do
        if params[:create_model]
          entity = FactoryBot.create(params[:create_model])
          self.send(http_method, action, params: { id: entity.id })
        else
          self.send(http_method, action)
        end
      end

      it { is_expected.to respond_with :not_found }
      it { expect(response.body).to include("not allowed") }
    end
  end
end
