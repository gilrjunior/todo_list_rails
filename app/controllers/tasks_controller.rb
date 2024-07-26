class TasksController < ApplicationController
  before_action :set_list
  before_action :set_task, only: %i[show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:index, :show, :edit, :update, :destroy]

  def index
    @tasks = @list.tasks
  end

  def show
  end

  def new
    @task = @list.tasks.new
  end

  def edit
    @tasks = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to list_tasks_url(@task.list_id), notice: "Tarefa criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def update
    if @task.update(task_params)
      redirect_to list_tasks_url(@task.list_id), notice: "Tarefa atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
      redirect_to list_tasks_url, notice: "Tarefa deletada com sucesso!"
  end

  def export
    TasksExportJob.perform_async(@list.id)
    redirect_to list_tasks_path, notice: 'Exportação iniciada!'
  end

  def download

    filename = "tarefas_#{@list.user.id}_#{@list.title}.xlsx"
    files_name = Dir.entries("tmp/files")

    files_name.delete(".")
    files_name.delete("..")

    if files_name.any? { |file| file == filename}

      file_path = Rails.root.join('tmp/files', filename)
      file = File.binread(file_path)
      send_data file, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', filename: 'tarefas.xlsx', disposition: 'attachment'  
    else
      redirect_to list_tasks_path, alert: 'Clique em Exportar ou Aguarde para baixar!'
    end    
  end

  private

    def set_list
      @list = List.find(params[:list_id])
    end

    def set_task
      @task = @list.tasks.find(params[:id])
    end

    def authorize_user!
      redirect_to lists_path, alert: 'Você não tem acesso!' unless @list.user == current_user
    end

    def task_params
      params.require(:task).permit(:title, :status, :list_id)
    end
end
