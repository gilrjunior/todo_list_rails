class TasksExportJob
  include Sidekiq::Job

  sidekiq_options queue: 'tasks'

  def perform(list_id)

      list = List.find_by(id: list_id)
      tasks = list.tasks

      temp_file_path = Rails.root.join('tmp/files', "tarefas_#{list.user.id}_#{list.title}.xlsx")

      p = Axlsx::Package.new
      workbook = p.workbook

      workbook.add_worksheet(name: 'Listas') do |sheet|
        sheet.add_row ['Lista','Título', 'Status']

        tasks.each do |task|

          sheet.add_row [task.list.title ,task.title, I18n.t("activerecord.statuses.task.#{task.status}", default: task.status.humanize)]

        end

      end

      p.serialize(temp_file_path)

      temp_file_path

  end
end
