# frozen_string_literal: true

class DocumentPresenter
  def initialize(document)
    @document = document
  end

    def present
        if @document.is_a?(ActiveRecord::Relation)
            @document.map { |document| format_document(document) }
        else
            format_document(@document)
        end
    end

  private

  def format_document(document)
    {
      id: document.id,
      name: document.name,
      file: document.file.url,
      company_id: document.company_id
    }
  end
end
