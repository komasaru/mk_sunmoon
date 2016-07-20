module MkSunmoon
  module Compute
    module_function

    #=========================================================================
    # Gregorian Calendar -> Julian Day
    #
    # * フリーゲルの公式を使用する
    #   [ JD ] = int( 365.25 × year )
    #          + int( year / 400 )
    #          - int( year / 100 )
    #          + int( 30.59 ( month - 2 ) )
    #          + day
    #          + 1721088
    #   ※上記の int( x ) は厳密には、x を超えない最大の整数
    #     ( ちなみに、[ 準JD ]を求めるなら + 1721088.5 が - 678912 となる )
    #
    # @param:  year
    # @param:  month
    # @param:  day
    # @param:  hour
    # @param:  minute
    # @param:  second
    # @return: jd ( ユリウス日 )
    #=========================================================================
    def gc2jd(year, month, day, hour = 0, min = 0, sec = 0)
      # 1月,2月は前年の13月,14月とする
      if month < 3
        year  -= 1
        month += 12
      end
      # 日付(整数)部分計算
      jd  = (365.25 * year).truncate
      jd += (year / 400.0).truncate
      jd -= (year / 100.0).truncate
      jd += (30.59 * (month - 2)).truncate
      jd += day
      jd += 1721088.125
      # 時間(小数)部分計算
      t  = sec / 3600.0
      t += min / 60.0
      t += hour
      t  = t / 24.0
      return jd + t
    end

    #=========================================================================
    # ΔT の計算
    #
    # * 1972-01-01 以降、うるう秒挿入済みの年+αまでは、以下で算出
    #     TT - UTC = ΔT + DUT1 = TAI + 32.184 - UTC = ΔAT + 32.184
    #   [うるう秒実施日一覧](http://jjy.nict.go.jp/QandA/data/leapsec.html)
    #
    # @param:  year
    # @param:  month
    # @param:  day
    # @return: dt
    #=========================================================================
    def compute_dt(year, month, day)
      ym = sprintf("%04d-%02d", year, month)
      y = year + (month - 0.5) / 12
      case
      when year < -500
        t = (y - 1820) / 100.0
        dt  = -20 + 32 * t ** 2
      when -500 <= year && year < 500
        t = y / 100.0
        dt  = 10583.6
             (-1014.41        + \
             (   33.78311     + \
             (   -5.952053    + \
             (   -0.1798452   + \
             (    0.022174192 + \
             (    0.0090316521) \
             * t) * t) * t) * t) * t) * t
      when 500 <= year && year < 1600
        t = (y - 1000) / 100.0
        dt  = 1574.2         + \
             (-556.01        + \
             (  71.23472     + \
             (   0.319781    + \
             (  -0.8503463   + \
             (  -0.005050998 + \
             (   0.0083572073) \
             * t) * t) * t) * t) * t) * t
      when 1600 <= year && year < 1700
        t = y - 1600
        dt  = 120           + \
             ( -0.9808      + \
             ( -0.01532     + \
             (  1.0 / 7129.0) \
             * t) * t) * t
      when 1700 <= year && year < 1800
        t = y - 1700
        dt  =  8.83           + \
             ( 0.1603         + \
             (-0.0059285      + \
             ( 0.00013336     + \
             (-1.0 / 1174000.0) \
             * t) * t) * t) * t
      when 1800 <= year && year < 1860
        t = y - 1800
        dt  = 13.72          + \
             (-0.332447      + \
             ( 0.0068612     + \
             ( 0.0041116     + \
             (-0.00037436    + \
             ( 0.0000121272  + \
             (-0.0000001699  + \
             ( 0.000000000875) \
             * t) * t) * t) * t) * t) * t) * t
      when 1860 <= year && year < 1900
        t = y - 1860
        dt  =  7.62          + \
             ( 0.5737        + \
             (-0.251754      + \
             ( 0.01680668    + \
             (-0.0004473624  + \
             ( 1.0 / 233174.0) \
             * t) * t) * t) * t) * t
      when 1900 <= year && year < 1920
        t = y - 1900
        dt  = -2.79      + \
             ( 1.494119  + \
             (-0.0598939 + \
             ( 0.0061966 + \
             (-0.000197  ) \
             * t) * t) * t) * t
      when 1920 <= year && year < 1941
        t = y - 1920
        dt  = 21.20     + \
             ( 0.84493  + \
             (-0.076100 + \
             ( 0.0020936) \
             * t) * t) * t
      when 1941 <= year && year < 1961
        t = y - 1950
        dt  = 29.07      + \
             ( 0.407     + \
             (-1 / 233.0 + \
             ( 1 / 2547.0) \
             * t) * t) * t
      when 1961 <= year && year < 1986
        case
        when ym < sprintf("%04d-%02d", 1972, 1)
          t = y - 1975
          dt = 45.45      + \
              ( 1.067     + \
              (-1 / 260.0 + \
              (-1 / 718.0)  \
              * t) * t) * t
        when ym < sprintf("%04d-%02d", 1972, 7); dt = Const::TT_TAI + 10
        when ym < sprintf("%04d-%02d", 1973, 1); dt = Const::TT_TAI + 11
        when ym < sprintf("%04d-%02d", 1974, 1); dt = Const::TT_TAI + 12
        when ym < sprintf("%04d-%02d", 1975, 1); dt = Const::TT_TAI + 13
        when ym < sprintf("%04d-%02d", 1976, 1); dt = Const::TT_TAI + 14
        when ym < sprintf("%04d-%02d", 1977, 1); dt = Const::TT_TAI + 15
        when ym < sprintf("%04d-%02d", 1978, 1); dt = Const::TT_TAI + 16
        when ym < sprintf("%04d-%02d", 1979, 1); dt = Const::TT_TAI + 17
        when ym < sprintf("%04d-%02d", 1980, 1); dt = Const::TT_TAI + 18
        when ym < sprintf("%04d-%02d", 1981, 7); dt = Const::TT_TAI + 19
        when ym < sprintf("%04d-%02d", 1982, 7); dt = Const::TT_TAI + 20
        when ym < sprintf("%04d-%02d", 1983, 7); dt = Const::TT_TAI + 21
        when ym < sprintf("%04d-%02d", 1985, 7); dt = Const::TT_TAI + 22
        when ym < sprintf("%04d-%02d", 1988, 1); dt = Const::TT_TAI + 23
        end
      when 1986 <= year && year < 2005
        #t = y - 2000
        #dt  = 63.86         + \
        #     ( 0.3345       + \
        #     (-0.060374     + \
        #     ( 0.0017275    + \
        #     ( 0.000651814  + \
        #     ( 0.00002373599) \
        #     * t) * t) * t) * t) * t
        case
        when ym < sprintf("%04d-%02d", 1988, 1); dt = Const::TT_TAI + 23
        when ym < sprintf("%04d-%02d", 1990, 1); dt = Const::TT_TAI + 24
        when ym < sprintf("%04d-%02d", 1991, 1); dt = Const::TT_TAI + 25
        when ym < sprintf("%04d-%02d", 1992, 7); dt = Const::TT_TAI + 26
        when ym < sprintf("%04d-%02d", 1993, 7); dt = Const::TT_TAI + 27
        when ym < sprintf("%04d-%02d", 1994, 7); dt = Const::TT_TAI + 28
        when ym < sprintf("%04d-%02d", 1996, 1); dt = Const::TT_TAI + 29
        when ym < sprintf("%04d-%02d", 1997, 7); dt = Const::TT_TAI + 30
        when ym < sprintf("%04d-%02d", 1999, 1); dt = Const::TT_TAI + 31
        when ym < sprintf("%04d-%02d", 2006, 1); dt = Const::TT_TAI + 32
        end
      when 2005 <= year && year < 2050
        case
        when ym < sprintf("%04d-%02d", 2006, 1); dt = Const::TT_TAI + 32
        when ym < sprintf("%04d-%02d", 2009, 1); dt = Const::TT_TAI + 33
        when ym < sprintf("%04d-%02d", 2012, 7); dt = Const::TT_TAI + 34
        when ym < sprintf("%04d-%02d", 2015, 7); dt = Const::TT_TAI + 35
        when ym < sprintf("%04d-%02d", 2017, 1); dt = Const::TT_TAI + 36
        when ym < sprintf("%04d-%02d", 2019, 1); dt = Const::TT_TAI + 37  # <= 第27回うるう秒実施までの暫定措置
        else
          t = y - 2000
          dt  = 62.92    + \
               ( 0.32217 + \
               ( 0.005589) \
               * t) * t
        end
      when 2050 <= year && year <= 2150
        dt  = -20 \
            + 32 * ((y - 1820) / 100.0) ** 2
            - 0.5628 * (2150 - y)
      when 2150 < year
        t = (y - 1820) / 100.0
        dt  = -20 + 32 * t ** 2
      end
      return dt
    end

    #=========================================================================
    # 日の出・入・南中の計算
    #
    # @param:  div(0: 出, 1: 入, 2: 南中)
    # @return: [time_str, hour_angle]
    #=========================================================================
    def compute_sun(div)
      time_val = compute_time_sun(div)
      if time_val == 0.0
        time_str = "--:--:--"
        angle    = "---"
      else
        time_str = val2hhmmss(time_val * 24.0)
        jy = (@jd + time_val + @dt / 86400.0 - 2451545.0) / 365.25
        lambda = compute_lambda_sun(jy)
        if div == 2
          angle = compute_height_ecliptic(jy, time_val, lambda, 0.0)
        else
          angle = compute_angle_ecliptic(jy, time_val, lambda, 0.0)
        end
      end
      return [time_str, angle]
    end

    #=========================================================================
    # 月の出・入・南中の計算
    #
    # @param:  div(0: 出, 1: 入, 2: 南中)
    # @return: [time_str, hour_angle]
    #=========================================================================
    def compute_moon(div)
      time_val = compute_time_moon(div)
      if time_val == 0.0
        time_str = "--:--:--"
        angle    = "---"
      else
        time_str = val2hhmmss(time_val * 24.0)
        jy = (@jd + time_val + @dt / 86400.0 - 2451545.0) / 365.25
        lambda = compute_lambda_moon(jy)
        beta   = compute_beta_moon(jy)
        if div == 2
          angle = compute_height_ecliptic(jy, time_val, lambda, beta)
        else
          angle = compute_angle_ecliptic(jy, time_val, lambda, beta)
        end
      end
      return [time_str, angle]
    end

    #=========================================================================
    # 日の出/日の入/日の南中計算
    #
    # @param:  div  (0: 出, 1: 入, 2: 南中)
    # @return: time (0.xxxx日)
    #=========================================================================
    def compute_time_sun(div)
      rev = 1    # 補正値初期値
      t   = 0.5  # 逐次計算時刻(日)初期設定

      while rev.abs > Const::CONVERGE
        jy = (@jd + t + @dt / 86400.0 - 2451545.0) / 365.25
        lambda = compute_lambda_sun(jy)
        dist   = compute_dist_sun(jy)
        alpha, delta = eclip2equat(jy, lambda, 0.0)
        unless div == 2  # 南中のときは計算しない
          r = 0.266994 / dist
          diff = 0.0024428 / dist
          height = -1 * r - Const::REFRACTION - @incl + diff
        end
        time_sidereal = compute_sidereal_time(jy, t)
        hour_angle_diff = compute_hour_angle_diff(
          alpha, delta, time_sidereal, height, div
        )
        return 0.0 if hour_angle_diff == 0.0
        # 仮定時刻に対する補正値
        rev = hour_angle_diff / 360.0
        t += rev
      end
      # 日の出・入がない場合は 0 とする
      t = 0.0 if t < 0.0 || t >= 1.0
      return t
    end

    #=========================================================================
    # 月の出/月の入/月の南中計算
    #
    # @param:  div  (0: 出, 1: 入, 2: 南中)
    # @return: time (0.xxxx日)
    #=========================================================================
    def compute_time_moon(div)
      rev = 1    # 補正値初期値
      t   = 0.5  # 逐次計算時刻(日)初期設定

      while rev.abs > Const::CONVERGE
        jy = (@jd + t + @dt / 86400.0 - 2451545.0) / 365.25
        lambda = compute_lambda_moon(jy)
        beta   = compute_beta_moon(jy)
        alpha, delta = eclip2equat(jy, lambda, beta)
        unless div == 2  # 南中のときは計算しない
          diff = compute_diff_moon(jy)
          height = -1 * Const::REFRACTION - @incl + diff
        end
        time_sidereal = compute_sidereal_time(jy, t)
        hour_angle_diff = compute_hour_angle_diff(
          alpha, delta, time_sidereal, height, div
        )
        # 仮定時刻に対する補正値
        rev = hour_angle_diff / 347.8
        t += rev
      end
      # 月の出/月の入りがない場合は 0 とする
      t = 0.0 if t < 0.0 || t >= 1.0
      return t
    end

    #=========================================================================
    # 太陽視黄経の計算
    #
    # @param:  jy (ユリウス年(JST))
    # @return: lambda
    #=========================================================================
    def compute_lambda_sun(jy)
      rm  = 0.0003 * Math.sin(Const::K * norm_angle(329.7  +   44.43  * jy))
      rm += 0.0003 * Math.sin(Const::K * norm_angle(352.5  + 1079.97  * jy))
      rm += 0.0004 * Math.sin(Const::K * norm_angle( 21.1  +  720.02  * jy))
      rm += 0.0004 * Math.sin(Const::K * norm_angle(157.3  +  299.30  * jy))
      rm += 0.0004 * Math.sin(Const::K * norm_angle(234.9  +  315.56  * jy))
      rm += 0.0005 * Math.sin(Const::K * norm_angle(291.2  +   22.81  * jy))
      rm += 0.0005 * Math.sin(Const::K * norm_angle(207.4  +    1.50  * jy))
      rm += 0.0006 * Math.sin(Const::K * norm_angle( 29.8  +  337.18  * jy))
      rm += 0.0007 * Math.sin(Const::K * norm_angle(206.8  +   30.35  * jy))
      rm += 0.0007 * Math.sin(Const::K * norm_angle(153.3  +   90.38  * jy))
      rm += 0.0008 * Math.sin(Const::K * norm_angle(132.5  +  659.29  * jy))
      rm += 0.0013 * Math.sin(Const::K * norm_angle( 81.4  +  225.18  * jy))
      rm += 0.0015 * Math.sin(Const::K * norm_angle(343.2  +  450.37  * jy))
      rm += 0.0018 * Math.sin(Const::K * norm_angle(251.3  +    0.20  * jy))
      rm += 0.0018 * Math.sin(Const::K * norm_angle(297.8  + 4452.67  * jy))
      rm += 0.0020 * Math.sin(Const::K * norm_angle(247.1  +  329.64  * jy))
      rm += 0.0048 * Math.sin(Const::K * norm_angle(234.95 +   19.341 * jy))
      rm += 0.0200 * Math.sin(Const::K * norm_angle(355.05 +  719.981 * jy))
      rm += (1.9146 - 0.00005 * jy) * Math.sin(Const::K * norm_angle(357.538 + 359.991 * jy))
      rm += norm_angle(280.4603 + 360.00769 * jy)
      return norm_angle(rm)
    end

    #=========================================================================
    # 太陽の距離の計算
    #
    # @param:  jy (ユリウス年(JST))
    # @return: distance
    #=========================================================================
    def compute_dist_sun(jy)
      r_sun  = 0.000007 * Math.sin(Const::PI_180 * norm_angle(156.0 +  329.6  * jy))
      r_sun += 0.000007 * Math.sin(Const::PI_180 * norm_angle(254.0 +  450.4  * jy))
      r_sun += 0.000013 * Math.sin(Const::PI_180 * norm_angle( 27.8 + 4452.67 * jy))
      r_sun += 0.000030 * Math.sin(Const::PI_180 * norm_angle( 90.0))
      r_sun += 0.000091 * Math.sin(Const::PI_180 * norm_angle(265.1 +  719.98 * jy))
      r_sun += (0.007256 - 0.0000002 * jy) * Math.sin(Const::PI_180 * norm_angle(267.54 + 359.991 * jy))
      r_sun  = 10.0 ** r_sun
      return r_sun
    end

    #=========================================================================
    # 月視黄経の計算
    #
    # @param:  jy (ユリウス年(JST))
    # @return: lambda
    #=========================================================================
    def compute_lambda_moon(jy)
      am  = 0.0006 * Math.sin(Const::PI_180 * norm_angle( 54.0   +    19.3    * jy))
      am += 0.0006 * Math.sin(Const::PI_180 * norm_angle( 71.0   +     0.2    * jy))
      am += 0.0020 * Math.sin(Const::PI_180 * norm_angle( 55.0   +    19.34   * jy))
      am += 0.0040 * Math.sin(Const::PI_180 * norm_angle(119.5   +     1.33   * jy))
      rm  = 0.0003 * Math.sin(Const::PI_180 * norm_angle(280.0   + 23221.3    * jy))
      rm += 0.0003 * Math.sin(Const::PI_180 * norm_angle(161.0   +    40.7    * jy))
      rm += 0.0003 * Math.sin(Const::PI_180 * norm_angle(311.0   +  5492.0    * jy))
      rm += 0.0003 * Math.sin(Const::PI_180 * norm_angle(147.0   + 18089.3    * jy))
      rm += 0.0003 * Math.sin(Const::PI_180 * norm_angle( 66.0   +  3494.7    * jy))
      rm += 0.0003 * Math.sin(Const::PI_180 * norm_angle( 83.0   +  3814.0    * jy))
      rm += 0.0004 * Math.sin(Const::PI_180 * norm_angle( 20.0   +   720.0    * jy))
      rm += 0.0004 * Math.sin(Const::PI_180 * norm_angle( 71.0   +  9584.7    * jy))
      rm += 0.0004 * Math.sin(Const::PI_180 * norm_angle(278.0   +   120.1    * jy))
      rm += 0.0004 * Math.sin(Const::PI_180 * norm_angle(313.0   +   398.7    * jy))
      rm += 0.0005 * Math.sin(Const::PI_180 * norm_angle(332.0   +  5091.3    * jy))
      rm += 0.0005 * Math.sin(Const::PI_180 * norm_angle(114.0   + 17450.7    * jy))
      rm += 0.0005 * Math.sin(Const::PI_180 * norm_angle(181.0   + 19088.0    * jy))
      rm += 0.0005 * Math.sin(Const::PI_180 * norm_angle(247.0   + 22582.7    * jy))
      rm += 0.0006 * Math.sin(Const::PI_180 * norm_angle(128.0   +  1118.7    * jy))
      rm += 0.0007 * Math.sin(Const::PI_180 * norm_angle(216.0   +   278.6    * jy))
      rm += 0.0007 * Math.sin(Const::PI_180 * norm_angle(275.0   +  4853.3    * jy))
      rm += 0.0007 * Math.sin(Const::PI_180 * norm_angle(140.0   +  4052.0    * jy))
      rm += 0.0008 * Math.sin(Const::PI_180 * norm_angle(204.0   +  7906.7    * jy))
      rm += 0.0008 * Math.sin(Const::PI_180 * norm_angle(188.0   + 14037.3    * jy))
      rm += 0.0009 * Math.sin(Const::PI_180 * norm_angle(218.0   +  8586.0    * jy))
      rm += 0.0011 * Math.sin(Const::PI_180 * norm_angle(276.5   + 19208.02   * jy))
      rm += 0.0012 * Math.sin(Const::PI_180 * norm_angle(339.0   + 12678.71   * jy))
      rm += 0.0016 * Math.sin(Const::PI_180 * norm_angle(242.2   + 18569.38   * jy))
      rm += 0.0018 * Math.sin(Const::PI_180 * norm_angle(  4.1   +  4013.29   * jy))
      rm += 0.0020 * Math.sin(Const::PI_180 * norm_angle( 55.0   +    19.34   * jy))
      rm += 0.0021 * Math.sin(Const::PI_180 * norm_angle(105.6   +  3413.37   * jy))
      rm += 0.0021 * Math.sin(Const::PI_180 * norm_angle(175.1   +   719.98   * jy))
      rm += 0.0021 * Math.sin(Const::PI_180 * norm_angle( 87.5   +  9903.97   * jy))
      rm += 0.0022 * Math.sin(Const::PI_180 * norm_angle(240.6   +  8185.36   * jy))
      rm += 0.0024 * Math.sin(Const::PI_180 * norm_angle(252.8   +  9224.66   * jy))
      rm += 0.0024 * Math.sin(Const::PI_180 * norm_angle(211.9   +   988.63   * jy))
      rm += 0.0026 * Math.sin(Const::PI_180 * norm_angle(107.2   + 13797.39   * jy))
      rm += 0.0027 * Math.sin(Const::PI_180 * norm_angle(272.5   +  9183.99   * jy))
      rm += 0.0037 * Math.sin(Const::PI_180 * norm_angle(349.1   +  5410.62   * jy))
      rm += 0.0039 * Math.sin(Const::PI_180 * norm_angle(111.3   + 17810.68   * jy))
      rm += 0.0040 * Math.sin(Const::PI_180 * norm_angle(119.5   +     1.33   * jy))
      rm += 0.0040 * Math.sin(Const::PI_180 * norm_angle(145.6   + 18449.32   * jy))
      rm += 0.0040 * Math.sin(Const::PI_180 * norm_angle( 13.2   + 13317.34   * jy))
      rm += 0.0048 * Math.sin(Const::PI_180 * norm_angle(235.0   +    19.34   * jy))
      rm += 0.0050 * Math.sin(Const::PI_180 * norm_angle(295.4   +  4812.66   * jy))
      rm += 0.0052 * Math.sin(Const::PI_180 * norm_angle(197.2   +   319.32   * jy))
      rm += 0.0068 * Math.sin(Const::PI_180 * norm_angle( 53.2   +  9265.33   * jy))
      rm += 0.0079 * Math.sin(Const::PI_180 * norm_angle(278.2   +  4493.34   * jy))
      rm += 0.0085 * Math.sin(Const::PI_180 * norm_angle(201.5   +  8266.71   * jy))
      rm += 0.0100 * Math.sin(Const::PI_180 * norm_angle( 44.89  + 14315.966  * jy))
      rm += 0.0107 * Math.sin(Const::PI_180 * norm_angle(336.44  + 13038.696  * jy))
      rm += 0.0110 * Math.sin(Const::PI_180 * norm_angle(231.59  +  4892.052  * jy))
      rm += 0.0125 * Math.sin(Const::PI_180 * norm_angle(141.51  + 14436.029  * jy))
      rm += 0.0153 * Math.sin(Const::PI_180 * norm_angle(130.84  +   758.698  * jy))
      rm += 0.0305 * Math.sin(Const::PI_180 * norm_angle(312.49  +  5131.979  * jy))
      rm += 0.0348 * Math.sin(Const::PI_180 * norm_angle(117.84  +  4452.671  * jy))
      rm += 0.0410 * Math.sin(Const::PI_180 * norm_angle(137.43  +  4411.998  * jy))
      rm += 0.0459 * Math.sin(Const::PI_180 * norm_angle(238.18  +  8545.352  * jy))
      rm += 0.0533 * Math.sin(Const::PI_180 * norm_angle( 10.66  + 13677.331  * jy))
      rm += 0.0572 * Math.sin(Const::PI_180 * norm_angle(103.21  +  3773.363  * jy))
      rm += 0.0588 * Math.sin(Const::PI_180 * norm_angle(214.22  +   638.635  * jy))
      rm += 0.1143 * Math.sin(Const::PI_180 * norm_angle(  6.546 +  9664.0404 * jy))
      rm += 0.1856 * Math.sin(Const::PI_180 * norm_angle(177.525 +   359.9905 * jy))
      rm += 0.2136 * Math.sin(Const::PI_180 * norm_angle(269.926 +  9543.9773 * jy))
      rm += 0.6583 * Math.sin(Const::PI_180 * norm_angle(235.700 +  8905.3422 * jy))
      rm += 1.2740 * Math.sin(Const::PI_180 * norm_angle(100.738 +  4133.3536 * jy))
      rm += 6.2887 * Math.sin(Const::PI_180 * norm_angle(134.961 +  4771.9886 * jy + am))
      rm += norm_angle(218.3161 + 4812.67881 * jy)
      return rm
    end

    #=========================================================================
    # 月視黄緯の計算
    #
    # @param:  jy (ユリウス年(JST))
    # @return: lambda
    #=========================================================================
    def compute_beta_moon(jy)
      bm  =  0.0005 * Math.sin(Const::PI_180 * norm_angle(307.0   +    19.4    * jy))
      bm +=  0.0026 * Math.sin(Const::PI_180 * norm_angle( 55.0   +    19.34   * jy))
      bm +=  0.0040 * Math.sin(Const::PI_180 * norm_angle(119.5   +     1.33   * jy))
      bm +=  0.0043 * Math.sin(Const::PI_180 * norm_angle(322.1   +    19.36   * jy))
      bm +=  0.0267 * Math.sin(Const::PI_180 * norm_angle(234.95  +    19.341  * jy))
      bt  =  0.0003 * Math.sin(Const::PI_180 * norm_angle(234.0   + 19268.0    * jy))
      bt +=  0.0003 * Math.sin(Const::PI_180 * norm_angle(146.0   +  3353.3    * jy))
      bt +=  0.0003 * Math.sin(Const::PI_180 * norm_angle(107.0   + 18149.4    * jy))
      bt +=  0.0003 * Math.sin(Const::PI_180 * norm_angle(205.0   + 22642.7    * jy))
      bt +=  0.0004 * Math.sin(Const::PI_180 * norm_angle(147.0   + 14097.4    * jy))
      bt +=  0.0004 * Math.sin(Const::PI_180 * norm_angle( 13.0   +  9325.4    * jy))
      bt +=  0.0004 * Math.sin(Const::PI_180 * norm_angle( 81.0   + 10242.6    * jy))
      bt +=  0.0004 * Math.sin(Const::PI_180 * norm_angle(238.0   + 23281.3    * jy))
      bt +=  0.0004 * Math.sin(Const::PI_180 * norm_angle(311.0   +  9483.9    * jy))
      bt +=  0.0005 * Math.sin(Const::PI_180 * norm_angle(239.0   +  4193.4    * jy))
      bt +=  0.0005 * Math.sin(Const::PI_180 * norm_angle(280.0   +  8485.3    * jy))
      bt +=  0.0006 * Math.sin(Const::PI_180 * norm_angle( 52.0   + 13617.3    * jy))
      bt +=  0.0006 * Math.sin(Const::PI_180 * norm_angle(224.0   +  5590.7    * jy))
      bt +=  0.0007 * Math.sin(Const::PI_180 * norm_angle(294.0   + 13098.7    * jy))
      bt +=  0.0008 * Math.sin(Const::PI_180 * norm_angle(326.0   +  9724.1    * jy))
      bt +=  0.0008 * Math.sin(Const::PI_180 * norm_angle( 70.0   + 17870.7    * jy))
      bt +=  0.0010 * Math.sin(Const::PI_180 * norm_angle( 18.0   + 12978.66   * jy))
      bt +=  0.0011 * Math.sin(Const::PI_180 * norm_angle(138.3   + 19147.99   * jy))
      bt +=  0.0012 * Math.sin(Const::PI_180 * norm_angle(148.2   +  4851.36   * jy))
      bt +=  0.0012 * Math.sin(Const::PI_180 * norm_angle( 38.4   +  4812.68   * jy))
      bt +=  0.0013 * Math.sin(Const::PI_180 * norm_angle(155.4   +   379.35   * jy))
      bt +=  0.0013 * Math.sin(Const::PI_180 * norm_angle( 95.8   +  4472.03   * jy))
      bt +=  0.0014 * Math.sin(Const::PI_180 * norm_angle(219.2   +   299.96   * jy))
      bt +=  0.0015 * Math.sin(Const::PI_180 * norm_angle( 45.8   +  9964.00   * jy))
      bt +=  0.0015 * Math.sin(Const::PI_180 * norm_angle(211.1   +  9284.69   * jy))
      bt +=  0.0016 * Math.sin(Const::PI_180 * norm_angle(135.7   +   420.02   * jy))
      bt +=  0.0017 * Math.sin(Const::PI_180 * norm_angle( 99.8   + 14496.06   * jy))
      bt +=  0.0018 * Math.sin(Const::PI_180 * norm_angle(270.8   +  5192.01   * jy))
      bt +=  0.0018 * Math.sin(Const::PI_180 * norm_angle(243.3   +  8206.68   * jy))
      bt +=  0.0019 * Math.sin(Const::PI_180 * norm_angle(230.7   +  9244.02   * jy))
      bt +=  0.0021 * Math.sin(Const::PI_180 * norm_angle(170.1   +  1058.66   * jy))
      bt +=  0.0022 * Math.sin(Const::PI_180 * norm_angle(331.4   + 13377.37   * jy))
      bt +=  0.0025 * Math.sin(Const::PI_180 * norm_angle(196.5   +  8605.38   * jy))
      bt +=  0.0034 * Math.sin(Const::PI_180 * norm_angle(319.9   +  4433.31   * jy))
      bt +=  0.0042 * Math.sin(Const::PI_180 * norm_angle(103.9   + 18509.35   * jy))
      bt +=  0.0043 * Math.sin(Const::PI_180 * norm_angle(307.6   +  5470.66   * jy))
      bt +=  0.0082 * Math.sin(Const::PI_180 * norm_angle(144.9   +  3713.33   * jy))
      bt +=  0.0088 * Math.sin(Const::PI_180 * norm_angle(176.7   +  4711.96   * jy))
      bt +=  0.0093 * Math.sin(Const::PI_180 * norm_angle(277.4   +  8845.31   * jy))
      bt +=  0.0172 * Math.sin(Const::PI_180 * norm_angle(  3.18  + 14375.997  * jy))
      bt +=  0.0326 * Math.sin(Const::PI_180 * norm_angle(328.96  + 13737.362  * jy))
      bt +=  0.0463 * Math.sin(Const::PI_180 * norm_angle(172.55  +   698.667  * jy))
      bt +=  0.0554 * Math.sin(Const::PI_180 * norm_angle(194.01  +  8965.374  * jy))
      bt +=  0.1732 * Math.sin(Const::PI_180 * norm_angle(142.427 +  4073.3220 * jy))
      bt +=  0.2777 * Math.sin(Const::PI_180 * norm_angle(138.311 +    60.0316 * jy))
      bt +=  0.2806 * Math.sin(Const::PI_180 * norm_angle(228.235 +  9604.0088 * jy))
      bt +=  5.1282 * Math.sin(Const::PI_180 * norm_angle( 93.273 +  4832.0202 * jy + bm))
      return bt
    end

    #=========================================================================
    # 月の視差の計算
    #
    # @param:  jy (ユリウス年)
    # @return: t  (出入時刻(0.xxxx日))
    #=========================================================================
    def compute_diff_moon(jy)
      t  =  0.0003 * Math.sin(Const::PI_180 * norm_angle(227.0  +  4412.0   * jy))
      t +=  0.0004 * Math.sin(Const::PI_180 * norm_angle(194.0  +  3773.4   * jy))
      t +=  0.0005 * Math.sin(Const::PI_180 * norm_angle(329.0  +  8545.4   * jy))
      t +=  0.0009 * Math.sin(Const::PI_180 * norm_angle(100.0  + 13677.3   * jy))
      t +=  0.0028 * Math.sin(Const::PI_180 * norm_angle(  0.0  +  9543.98  * jy))
      t +=  0.0078 * Math.sin(Const::PI_180 * norm_angle(325.7  +  8905.34  * jy))
      t +=  0.0095 * Math.sin(Const::PI_180 * norm_angle(190.7  +  4133.35  * jy))
      t +=  0.0518 * Math.sin(Const::PI_180 * norm_angle(224.98 +  4771.989 * jy))
      t +=  0.9507 * Math.sin(Const::PI_180 * norm_angle(90.0))
      return t
    end

    #=========================================================================
    # 角度の正規化
    #
    # @param:  angle
    # @return: angle
    #=========================================================================
    def norm_angle(angle)
      if angle < 0
        angle1  = angle * (-1)
        angle2  = (angle1 / 360.0).truncate
        angle1 -= 360 * angle2
        angle1  = 360 - angle1
      else
        angle1  = (angle / 360.0).truncate
        angle1  = angle - 360.0 * angle1
      end
      return angle1
    end

    #=========================================================================
    # 黄道座標 -> 赤道座標変換
    #
    # @param:  jy (ユリウス年(JST))
    # @param:  lambda (黄経)
    # @param:  beta   (黄緯)
    # @return: [alpha(R.A.), delta(Decl.)]
    #=========================================================================
    def eclip2equat(jy, lambda, beta)
      eps = (23.439291 - 0.000130042 * jy) * Const::PI_180
      lambda *= Const::PI_180
      beta   *= Const::PI_180
      a  =      Math.cos(beta) * Math.cos(lambda)
      b  = -1 * Math.sin(beta) * Math.sin(eps)
      b +=      Math.cos(beta) * Math.sin(lambda) * Math.cos(eps)
      c  =      Math.sin(beta) * Math.cos(eps)
      c +=      Math.cos(beta) * Math.sin(lambda) * Math.sin(eps)
      alpha  = b / a
      alpha  = Math.atan(alpha) / Const::PI_180
      alpha += 180 if a < 0
      delta  = Math.asin(c) / Const::PI_180
      return [alpha, delta]
    end

    #=========================================================================
    # 恒星時Θ(度)の計算
    #
    # @param:  jy (ユリウス年(JST))
    # @param:  t  (時刻(0.xxxx日))
    # @param:  longitude
    # @return: sidereal time
    #=========================================================================
    def compute_sidereal_time(jy, t)
      val  = 325.4606       + \
            (360.007700536  + \
            (  0.00000003879) \
            * jy) * jy        \
            + 360.0 * t + @lon
      return norm_angle(val)
    end

    #=========================================================================
    # 出入点(k)の時角(tk)と天体の時角(t)との差(dt=tk-t)を計算する
    #
    # @param:  alpha(R.A.)  (赤経)
    # @param:  delta(Decl.) (赤緯)
    # @param:  time_sidereal(恒星時Θ(度))
    # @param:  height       (出没高度(度))
    # @param:  div          (0: 出, 1: 入, 2: 南中)
    # @return: hour angle difference (時角の差　dt)
    #=========================================================================
    def compute_hour_angle_diff(alpha, delta, time_sidereal, height, div)
      if div == 2
        tk = 0
      else
        tk  = Math.sin(Const::PI_180 * height)
        tk -= Math.sin(Const::PI_180 * delta) * Math.sin(Const::PI_180 * @lat)
        tk /= Math.cos(Const::PI_180 * delta) * Math.cos(Const::PI_180 * @lat)
        # 出没点の時角
        return 0.0 if tk.abs > 1
        tk = Math.acos(tk) / Const::PI_180
        # tkは出のときマイナス、入のときプラス
        tk = -tk if div == 0 && tk > 0
        tk = -tk if div == 1 && tk < 0
      end
      # 天体の時角
      t = time_sidereal - alpha
      dt = tk - t
      # dtの絶対値を180°以下に調整
      while dt >  180.0; dt -= 360.0; end
      while dt < -180.0; dt += 360.0; end
      return dt
    end

    #=========================================================================
    # 時刻：数値->時刻：時分変換 (xx.xxxx -> hh:mm:ss)
    #
    # @param:  time value  (時刻, xx.xxxx日)
    # @return: time string (時刻, hh:mm:ss)
    #=========================================================================
    def val2hhmmss(val)
      val_h = val.truncate            # 整数部(時)
      val_2 = val - val_h             # 小数部
      val_m = (val_2 * 60).truncate   # (分)計算
      val_3 = val_2 - (val_m / 60.0)  # (秒)計算
      val_s = (val_3 * 60 * 60).round
      if val_s == 60
        val_s = 0
        val_m +=1
      end
      if val_m == 60
        val_m = 0
        val_h += 1
      end
      return sprintf("%02d:%02d:%02d", val_h, val_m, val_s)
    end

    #=========================================================================
    # 時刻(t)における黄経、黄緯(λ(jy),β(jy))の天体の方位角(ang)計算
    #
    # @param:  lambda (天体の黄経(λ(T)(度)))
    # @param:  beta   (天体の黄緯(β(T)(度)))
    # @param:  jy     (ユリウス年)
    # @param:  t      (時刻(0.xxxx日))
    # @return: angle  (角度(xx.x度))
    #=========================================================================
    def compute_angle_ecliptic(jy, t, lambda, beta)
      res = eclip2equat(jy, lambda, beta)
      return compute_angle_equator(jy, t, *res)
    end

    #=========================================================================
    # 時刻(t)における赤経、赤緯(α(jy),δ(jy))(度)の天体の方位角(ang)計算
    #
    # @param:  jy    (ユリウス年)
    # @param:  t     (時刻 (0.xxxx日))
    # @param:  alpha (天体の赤経(α(jy)(度)))
    # @param:  delta (天体の赤緯(δ(jy)(度)))
    # @return: angle (角度(xx.x度))
    #=========================================================================
    def compute_angle_equator(jy, t, alpha, delta)
      time_sidereal = compute_sidereal_time(jy, t)
      hour_angle = time_sidereal - alpha
      a_0  = -1.0 * Math.cos(Const::PI_180 * delta) \
                  * Math.sin(Const::PI_180 * hour_angle)
      a_1  = Math.sin(Const::PI_180 * delta) \
           * Math.cos(Const::PI_180 * @lat)  \
           - Math.cos(Const::PI_180 * delta) \
           * Math.sin(Const::PI_180 * @lat)  \
           * Math.cos(Const::PI_180 * hour_angle)
      angle  = Math.atan(a_0 / a_1) / Const::PI_180
      angle += 360.0 if a_1 > 0.0 && angle < 0.0
      angle += 180.0 if a_1 < 0.0
      return angle
    end

    #=========================================================================
    # 時刻(t)における黄経、黄緯(λ(jy),β(jy))の天体の高度(height)計算
    #
    # @param:  jy     (ユリウス年)
    # @param:  t      (時刻(0.xxxx日))
    # @param:  lambda (天体の黄経(λ(T)(度)))
    # @param:  beta   (天体の黄緯(β(T)(度)))
    # @return: height (高度(xx.x度))
    #=========================================================================
    def compute_height_ecliptic(jy, t, lambda, beta)
      res = eclip2equat(jy, lambda, beta)
      return compute_height_equator(jy, t, *res)
    end

    #=========================================================================
    # 時刻(t)における赤経、赤緯(α(jy),δ(jy))(度)の天体の高度(height)計算
    #
    # @param:  jy     (ユリウス年)
    # @param:  t      (時刻 (0.xxxx日))
    # @param:  alpha  (天体の赤経α(jy)(度))
    # @param:  delta  (天体の赤緯δ(jy)(度))
    # @return: height (高度(xx.x度))
    #=========================================================================
    def compute_height_equator(jy, t, alpha, delta)
      time_sidereal = compute_sidereal_time(jy, t)
      sidereal = time_sidereal - alpha
      height  = Math.sin(Const::PI_180 * delta) \
              * Math.sin(Const::PI_180 * @lat)  \
              + Math.cos(Const::PI_180 * delta) \
              * Math.cos(Const::PI_180 * @lat)  \
              * Math.cos(Const::PI_180 * sidereal)
      height  = Math.asin(height) / Const::PI_180

      # 大気差補正
      # [ 以下の内、3-2の計算式を採用 ]
      # # 1. 日月出没計算 by「菊池さん」による計算式
      # #   [ http://kikuchisan.net/ ]
      # h = 0.0167 / Math.tan( Const::PI_180 * ( height + 8.6 / ( height + 4.4 ) ) )

      # # 2. 中川用語集による計算式 ( 5度 - 85度用 )
      # #   [ http://www.es.ris.ac.jp/~nakagawa/term_collection/yogoshu/ll/ni.htm ]
      # h  = 58.1      / Math.tan( height )
      # h -=  0.07     / Math.tan( height ) ** 3
      # h +=  0.000086 / Math.tan( height ) ** 5
      # h *= 1 / 3600.0

      # # 3-1. フランスの天文学者ラドー(R.Radau)の平均大気差と１秒程度の差で大気差を求めることが可能
      # # ( 標準的大気(気温10ﾟC，気圧1013.25hPa)の場合 )
      # # ( 視高度30ﾟ以上 )
      # h  = ( 58.294  / 3600.0 ) * Math.tan( Const::PI_180 * ( 90.0 - height ) )
      # h -= (  0.0668 / 3600.0 ) * Math.tan( Const::PI_180 * ( 90.0 - height ) ) ** 3

      # 3-2. フランスの天文学者ラドー(R.Radau)の平均大気差と１秒程度の差で大気差を求めることが可能
      # ( 標準的大気(気温10ﾟC，気圧1013.25hPa)の場合 )
      # ( 視高度 4ﾟ以上 )
      a = Math.tan(Const::PI_180 * (90.0 - height))
      h  = (58.76   + \
           (-0.406  + \
           (- 0.0192) \
           * a) * a) * a * 1 / 3600.0

      # # 3-3. さらに、上記の大気差(3-1,3-2)を気温、気圧を考慮する
      # # ( しかし、気温・気圧を考慮してもさほど変わりはない )
      # pres = 1013.25 # <= 変更
      # temp = 30.0    # <= 変更
      # h *= pres / 1013.25
      # h *= 283.25 / ( 273.15 + temp )

      return height + h
    end
  end
end

