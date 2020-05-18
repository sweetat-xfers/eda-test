class BigTransaction < Transaction
    private def pre_trade_check?
      amt.to_f < 999.0
    end
end