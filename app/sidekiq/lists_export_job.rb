class ListsExportJob
  include Sidekiq::Job

  sidekiq_options queue: 'lists'

  def perform(user_id)

      lists = List.where(user_id: user_id)

      temp_file_path = Rails.root.join('tmp/files', "listas_#{user_id}.xlsx")

      book = Spreadsheet::Workbook.new 

      sheet = book.create_worksheet 

      sheet.row(0).push('Título', 'Descrição') 

      i=1

      lists.each do |list|

        sheet.row(i).push(list.title.to_s, list.description.to_s)
        i+=1

      end

      book.write(temp_file_path)

      temp_file_path

  end
  
end
