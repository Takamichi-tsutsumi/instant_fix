class SolutionsController < ApplicationController

	def new
		@solution = Solution.new
		@error_message = ErrorMessage.find(params[:error_message_id])
		p @error_message
	end

	def create
		@error_message = ErrorMessage.find(params[:error_message_id])
		@solution = Solution.new(solution_params)
		@solution.attributes = {error_message_id: @error_message.id, good: 0, user_id: current_user.id}
		if @solution.save
			redirect_to @error_message
		else
			render :new
		end
	end

	def good
		@solution = Solution.find(params[:id])
		@solution.good += 1
		if @solution.save
      		# UserMailer.good_mail(@solution).deliver_later
    	end
		respond_to do |format|
			format.js {render :good, @solution => @solution}
		end
	end

	private
	def solution_params
		params.require(:solution).permit(:solution)
	end
end
