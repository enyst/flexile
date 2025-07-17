# frozen_string_literal: true

class EquityBuybackPresenter
  def initialize(equity_buyback)
    @equity_buyback = equity_buyback
  end

    def present
        if @equity_buyback.is_a?(ActiveRecord::Relation)
            @equity_buyback.map { |equity_buyback| format_equity_buyback(equity_buyback) }
        else
            format_equity_buyback(@equity_buyback)
        end
    end

  private

  def format_equity_buyback(equity_buyback)
    {
      id: equity_buyback.id,
      price: equity_buyback.price,
      quantity: equity_buyback.quantity,
      company_id: equity_buyback.company_id
    }
  end
end
