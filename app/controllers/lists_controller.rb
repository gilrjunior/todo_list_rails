class ListsController < ApplicationController
  before_action :set_user
  before_action :set_list, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show, :edit, :update, :destroy]

  
  def index
    @lists = @user.lists
  end

  def show
  end

  def new
    @list = @user.lists.new
    
  end

  def edit
  end

  def create
    @list = List.new(list_params)

      if @list.save
        redirect_to list_url(@list), notice: "Lista criada com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
  end

  def update
      if @list.update(list_params)
        redirect_to list_url(@list), notice: "Lista atualizada com sucesso!"
      else
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @list.destroy!
      redirect_to lists_url, notice: "Lista deletada com sucesso!" 
  end

  def export
      ListsExportJob.perform_async(@user.id)
      redirect_to lists_path, notice: 'Exportação iniciada!'
  end

  def download

    files_name = Dir.entries("tmp/files")

    files_name.delete(".")
    files_name.delete("..")

    if files_name.any? { |file| file == "listas_#{@user.id}.xlsx" }

      file_path = Rails.root.join('tmp', 'files', "listas_#{@user.id}.xlsx")
      file = File.binread(file_path)
      send_data file, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', filename: 'listas.xlsx', disposition: 'attachment'  
    else
      redirect_to lists_path, alert: 'Clique em Exportar ou Aguarde para baixar!'
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
