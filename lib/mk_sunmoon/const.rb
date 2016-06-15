module MkSunmoon
  module Const
    USAGE       = "[USAGE] MkSunmoon.new([date[, latitude[, longitude[, altitude]]]])"
    MSG_ERR_1   = "[ERROR] Invalid date! (Should be YYYYMMDD format)"
    MSG_ERR_2   = "[ERROR] Invalide latitude! (Should be -90.0 < latitude < 90.0)"
    MSG_ERR_3   = "[ERROR] Invalide longitude! (Should be -180.0 < longitude < 180.0)"
    MSG_ERR_4   = "[ERROR] Invalide altitude! (Should be 0.0 < altitude < 10000)"
    LAT_MATSUE  = 35.47222222
    LON_MATSUE  = 133.05055556
    PI          = 3.141592653589793238462
    PI_180      = 0.017453292519943295
    K           = 0.017453292519943295
    OFFSET_JST  = 0.375
    DIGIT       = 2
    CONVERGE    = 0.00005
    REFRACTION  = 0.585556
    INCLINATION = 0.0353333
    TT_TAI      = 32.184
  end
end

