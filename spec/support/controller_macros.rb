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
end
