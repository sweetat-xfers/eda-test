class SmallTransaction < BaseTransaction
    private def pre_trade_check?
      amt.to_f < 100.0
    end
end