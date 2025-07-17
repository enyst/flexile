# frozen_string_literal: true

class InvoicePresenter
  def initialize(invoice)
    @invoice = invoice
  end

    def present
        if @invoice.is_a?(ActiveRecord::Relation)
            @invoice.map { |invoice| format_invoice(invoice) }
        else
            format_invoice(@invoice)
        end
    end

  private

  def format_invoice(invoice)
    {
      id: invoice.external_id,
      number: invoice.invoice_number,
      date: invoice.invoice_date,
      due_date: invoice.due_on,
      amount: invoice.total_amount_in_usd_cents,
      status: invoice.status,
      company_id: invoice.company_id,
      contact_id: invoice.user_id
    }
  end
end
