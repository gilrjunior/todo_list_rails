require 'axlsx'

class ListsExportJob
  
  include Sidekiq::Job

  sidekiq_options queue: 'lists'

  def perform(user_id)

      lists = List.where(user_id: user_id)

      temp_file_path = Rails.root.join('tmp/files', "listas_#{user_id}.xlsx")

      p = Axlsx::Package.new
      workbook = p.workbook

      workbook.add_worksheet(name: 'Listas') do |sheet|
        sheet.add_row ['Título', 'Descrição']

        lists.each do |list|

          sheet.add_row [list.title.to_s, list.description.to_s]

        end

      end

      p.serialize(temp_file_path)

      temp_file_path

  end
  
end
