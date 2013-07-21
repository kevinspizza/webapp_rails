class SessionsController < ApplicationController
	def new
    	@titre = "S'identifier"
  	end
	
	def create
	  	user = User.authenticate(params[:session][:email], params[:session][:password])
	  	if user.nil?
	   	 	flash.now[:notice] = "Combinaison Email/Mot de passe invalide."
      		@titre = "S'identifier"
      		render 'new'
	  	else
			sign_in user
			redirect_to user
	  	end
	end

	def destroy
		sign_out
		flash[:notice] = "Deconnexion effectuee"
		redirect_to signin_path
	end
end
