require "spec_helper"

describe MkSunmoon::Const do
  context "USAGE" do
    it do
      expect(MkSunmoon::Const::USAGE).to \
      eq "[USAGE] MkSunmoon.new([date[, latitude[, longitude[, altitude]]]])"
    end
  end

  context "MSG_ERR_1" do
    it { expect(MkSunmoon::Const::MSG_ERR_1).to eq "[ERROR] Invalid date! (Should be YYYYMMDD format)" }
  end

  context "MSG_ERR_2" do
    it { expect(MkSunmoon::Const::MSG_ERR_2).to eq "[ERROR] Invalide latitude! (Should be -90.0 < latitude < 90.0)" }
  end

  context "MSG_ERR_3" do
    it { expect(MkSunmoon::Const::MSG_ERR_3).to eq "[ERROR] Invalide longitude! (Should be -180.0 < longitude < 180.0)" }
  end

  context "MSG_ERR_4" do
    it { expect(MkSunmoon::Const::MSG_ERR_4).to eq "[ERROR] Invalide altitude! (Should be 0.0 < altitude < 10000)" }
  end

  context "LAT_MATSUE" do
    it { expect(MkSunmoon::Const::LAT_MATSUE).to be_within(1.0e-8).of(35.47222222) }
  end

  context "LON_MATSUE" do
    it { expect(MkSunmoon::Const::LON_MATSUE).to be_within(1.0e-8).of(133.05055556) }
  end

  context "PI" do
    it { expect(MkSunmoon::Const::PI).to be_within(1.0e-21).of(3.141592653589793238462) }
  end

  context "PI_180" do
    it { expect(MkSunmoon::Const::PI_180).to be_within(1.0e-18).of(0.017453292519943295) }
  end

  context "K" do
    it { expect(MkSunmoon::Const::K).to be_within(1.0e-18).of(0.017453292519943295) }
  end

  context "OFFSET_JST" do
    it { expect(MkSunmoon::Const::OFFSET_JST).to be_within(1.0e-3).of(0.375) }
  end

  context "CONVERGE" do
    it { expect(MkSunmoon::Const::CONVERGE).to be_within(1.0e-5).of(0.00005) }
  end

  context "REFRACTION" do
    it { expect(MkSunmoon::Const::REFRACTION).to be_within(1.0e-6).of(0.585556) }
  end

  context "INCLINATION" do
    it { expect(MkSunmoon::Const::INCLINATION).to be_within(1.0e-7).of(0.0353333) }
  end
end

