class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      
    file_path = Rails.root.join('tmp', 'files', @document.file.filename.to_s)

    File.open(file_path, 'wb') do |f|
      f.write(@document.file.download)
    end

    TasksImportJob.perform_async(file_path.to_s, (params[:list_id]))

      redirect_to list_tasks_path, notice: 'Upload Iniciado.'
    else
      render :new
    end
  end

  def template
    filename = "template_importacao_tarefas.xlsx"

    file_path = Rails.root.join('public', filename)
    file = File.binread(file_path)
    send_data file, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', filename: filename, disposition: 'attachment'   
  end

  def document_params
    params.require(:document).permit(:file)
  end

end
