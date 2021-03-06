class ErrorMessagesController < ApplicationController
  before_action :set_error_message, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]

  def show
    @solutions = @error_message.solutions
    @user = current_user
  end

  def new
    @error_message = ErrorMessage.new
  end

  def create
    @error_message = ErrorMessage.new(error_message_params)
    @error_message.user_id = current_user.id
    if @error_message.save
      redirect_to action: :show, id: @error_message.id
    else
      render :new
    end
  end

  def edit
    @error_message = ErrorMessage.find(params[:id])
  end

  # ひとつ前のバージョンとしてerror_change_logを作成
  def update
    error_log = @error_message.error_change_logs.build
    error_log.attributes = {title: @error_message.title, detail: @error_message.detail,
     error_code: @error_message.error_code, knowledge: @error_message.knowledge}
    @error_message.attributes = error_message_params
    if @error_message.save
      redirect_to action: :show, id: params[:id]
    else
      render :edit
    end
  end

  def clip
    @user = current_user
    @error_message = ErrorMessage.find(params[:id])
    clip = Clip.new(user_id: @user.id, error_message_id: @error_message.id)
    clip.save
    respond_to do |format|
      format.js
    end
  end

  private
  def error_message_params
    params.require(:error_message).permit(:title, :error_code, :detail, :knowledge)
  end

  def set_error_message
    @error_message = ErrorMessage.find(params[:id])
  end
end
