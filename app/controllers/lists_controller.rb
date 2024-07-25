class ListsController < ApplicationController
  before_action :set_user
  before_action :set_list, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy]

  
  def index
    @lists = @user.list
  end

  def show
  end

  def new
    @list = @user.list.new
    
  end

  def edit
  end

  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to list_url(@list), notice: "Lista criada com sucesso!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to list_url(@list), notice: "Lista atualizada com sucesso!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_url, notice: "Lista deletada com sucesso!" }
    end
  end

  private

    def set_user
      @user = current_user
    end

    def set_list
      @list = List.find(params[:id])
    end

    def authorize_user!
      redirect_to lists_path, alert: 'Você não tem acesso!' unless @list.user == current_user
    end

    def list_params
      params.require(:list).permit(:title, :description, :user_id)
    end
end