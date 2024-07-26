require 'simple_xlsx_reader'

class TasksImportJob
  include Sidekiq::Job

  sidekiq_options queue: 'tasks'

  def perform(file_path, list_id)
    
    book = SimpleXlsxReader.open(file_path)

    worksheets = book.sheets

    worksheets.each do |worksheet|
      worksheet.rows.each_with_index do |row, index|

        next if index == 0 && row[0] == "Lista" || (row[1].blank?)

        task = Task.new(
          title: row[1],
          status: row[2],
          list_id: list_id
        )

        task.save

      end
    end
  end
end