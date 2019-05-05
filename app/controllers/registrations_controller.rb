class RegistrationsController < Devise::RegistrationsController
	before_action :prevent_sign_up

private
    def prevent_sign_up
        redirect_to new_user_session_path and return
    end
end
