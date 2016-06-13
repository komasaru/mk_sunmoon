require "mk_sunmoon/version"
require "mk_sunmoon/argument"
require "mk_sunmoon/const"
require "mk_sunmoon/sunmoon"

module MkSunmoon
  def self.new(*args)
    res = MkSunmoon::Argument.new(*args).get_args
    return if res == []
    return MkSunmoon::Sunmoon.new(res)
  end
end
