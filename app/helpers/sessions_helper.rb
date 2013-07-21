module SessionsHelper
	def sign_in(user)
    	session[:remember_token] = user.id
    	@current_user ||= current_user
  	end

  	def sign_out
  		session[:remember_token] = nil
  		@current_user = nil
  	end

  	def signed_in?
    	!current_user.nil?
  	end

    def deny_access
      redirect_to signin_path, :notice => "Il faut d'abord s'identifier"
    end

    def current_user?(user)
      user == current_user
    end

  private

    def current_user
  		@current_user ||= User.where(:id => session[:remember_token]).first if session[:remember_token]
	   end
end
