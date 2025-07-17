# frozen_string_literal: true

class DividendPresenter
  def initialize(dividend)
    @dividend = dividend
  end

    def present
        if @dividend.is_a?(ActiveRecord::Relation)
            @dividend.map { |dividend| format_dividend(dividend) }
        else
            format_dividend(@dividend)
        end
    end

  private

  def format_dividend(dividend)
    {
      id: dividend.id,
      amount: dividend.amount,
      pay_date: dividend.pay_date,
      company_id: dividend.company_id
    }
  end
end
