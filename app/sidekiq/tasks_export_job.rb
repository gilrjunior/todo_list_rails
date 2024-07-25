class TasksExportJob
  include Sidekiq::Job

  sidekiq_options queue: 'tasks'

  def perform(list_id)

      list = List.find_by(id: list_id)
      tasks = list.tasks

      temp_file_path = Rails.root.join('tmp/files', "tarefas_#{list.user.id}_#{list.title}.xlsx")

      book = Spreadsheet::Workbook.new 

      sheet = book.create_worksheet
      
      sheet.row(0).push('Lista','Título', 'Status')

      i=1

      tasks.each do |task|

        sheet.row(i).push(task.list.title ,task.title, I18n.t("activerecord.statuses.task.#{task.status}", default: task.status.humanize))
        i+=1

      end

      book.write(temp_file_path)

      temp_file_path
  end
end
