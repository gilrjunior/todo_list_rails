class TasksController < ApplicationController
  before_action :set_list
  before_action :set_task, only: %i[show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:index, :show, :edit, :update, :destroy]

  def index
    @tasks = @list.task
  end

  def show
  end

  def new
    @task = @list.task.new
  end

  def edit
    @tasks = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to list_tasks_url(@task.list_id), notice: "Tarefa criada com sucesso!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to list_tasks_url(@task.list_id), notice: "Tarefa atualizada com sucesso!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to list_tasks_url, notice: "Tarefa deletada com sucesso!" }
    end
  end

  private

    def set_list
      @list = List.find(params[:list_id])
    end

    def set_task
      @task = @list.task.find(params[:id])
    end

    def authorize_user!
      redirect_to lists_path, alert: 'Você não tem acesso!' unless @list.user == current_user
    end

    def task_params
      params.require(:task).permit(:title, :status, :list_id)
    end
end
