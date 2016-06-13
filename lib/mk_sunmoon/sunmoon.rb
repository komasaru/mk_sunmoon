require 'mk_sunmoon/compute'

module MkSunmoon
  class Sunmoon
    attr_reader :year, :month, :day, :lat, :lon, :alt

    include MkSunmoon::Compute

    def initialize(args)
      @year, @month, @day, @lat, @lon, @alt = args
      @jd       = gc2jd(year, month, day)
      @jd_jst   = @jd + Const::OFFSET_JST
      @dt       = compute_dt(year, month, day)
      @incl     = Const::INCLINATION * Math.sqrt(@alt)
    end

    #=========================================================================
    # 日の出(SUNRISE)
    #=========================================================================
    def sunrise
      return compute_sun(0)
    end

    #=========================================================================
    # 日の入(SUNSET)
    #=========================================================================
    def sunset
      return compute_sun(1)
    end

    #=========================================================================
    # 日の南中(SUN MERIDIAN PASSAGE)
    #=========================================================================
    def sun_mp
      return compute_sun(2)
    end

    #=========================================================================
    # 月の出(MOONRISE)
    #=========================================================================
    def moonrise
      return compute_moon(0)
    end

    #=========================================================================
    # 月の入(MOONSET)
    #=========================================================================
    def moonset
      return compute_moon(1)
    end

    #=========================================================================
    # 月の南中(MOON MERIDIAN PASSAGE)
    #=========================================================================
    def moon_mp
      return compute_moon(2)
    end
  end
end

