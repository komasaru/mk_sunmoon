require "date"

module MkSunmoon
  class Argument
    def initialize(*args)
      @date, @lat, @lon, @alt = args
    end

    #=========================================================================
    # 引数取得
    #
    # * コマンドライン引数を取得して日時の妥当性チェックを行う
    #   コマンドライン引数無指定なら、現在日とする。
    # *  -90.0 < 緯度 <    90.0
    # * -180.0 < 経度 <   180.0
    # *    0.0 < 標高 < 10000.0
    #
    # @return: [year, month, day, lat, lon, alt] (when error, [])
    #=========================================================================
    def get_args
      date = get_date;      return [] unless date
      lat  = get_latitude;  return [] unless lat
      lon  = get_longitude; return [] unless lon
      alt  = get_altitude;  return [] unless alt
      return [*date, lat, lon, alt]
    end

    private

    def get_date
      @date ||= Time.now.strftime("%Y%m%d")
      unless @date =~ /^\d{8}$/
        puts Const::MSG_ERR_1
        return nil
      end
      year, month, day = @date[0,4].to_i, @date[4,2].to_i, @date[6,2].to_i
      unless Date.valid_date?(year, month, day)
        puts Const::MSG_ERR_1
        return nil
      end
      return [year, month, day]
    end

    def get_latitude
      @lat ||= Const::LAT_MATSUE
      unless @lat.to_s =~ /^[+-]?[0-8]?\d?(\.\d*)?$/
        puts Const::MSG_ERR_2
        return nil
      end
      return @lat.to_f
    end

    def get_longitude
      @lon ||= Const::LON_MATSUE
      unless @lon.to_s =~ /^[+-]?(\d{,2}|1[0-7]\d?)(\.\d*)?$/
        puts Const::MSG_ERR_3
        return nil
      end
      return @lon.to_f
    end

    def get_altitude
      @alt ||= 0.0
      unless @alt.to_s =~ /^\d{,4}(\.\d*)?$/
        puts Const::MSG_ERR_4
        return nil
      end
      return @alt.to_f
    end
  end
end

