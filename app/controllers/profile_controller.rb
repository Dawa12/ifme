class ProfileController < ApplicationController
	before_filter :if_not_signed_in

	def index
		# If the specified profile doesn't exist, view the current user's profile
		user = User.find(params[:userid])
		user = current_user if user.nil?

		# Determine how the profile should be displayed based on the userid
		if user == current_user
			@triggers = Trigger.where(userid: current_user.id).all
		elsif current_user.allies_by_status(:accepted).include? user
			@triggers = Trigger.where(userid: params[:userid]).all
		end

		@profile = user
		@page_title = @profile.name
	end

	private

	def if_not_signed_in
      if !user_signed_in?
        respond_to do |format|
          format.html { redirect_to new_user_session_path }
          format.json { head :no_content }
        end
      end
    end
end
