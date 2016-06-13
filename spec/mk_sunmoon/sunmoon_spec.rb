require "spec_helper"

describe MkSunmoon::Sunmoon do
  context "#new([2016, 6, 10, 35.47222222, 133.05055556, 0])" do
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }

    context "object" do
      it { expect(sm).to be_an_instance_of(MkSunmoon::Sunmoon) }
    end

    context "year" do
      it { expect(sm.year).to eq 2016 }
    end

    context "month" do
      it { expect(sm.month).to eq 6 }
    end

    context "day" do
      it { expect(sm.day).to eq 10}
    end

    context "lat" do
      it { expect(sm.lat).to eq 35.47222222 }
    end

    context "lon" do
      it { expect(sm.lon).to eq 133.05055556}
    end

    context "alt" do
      it { expect(sm.alt).to eq 0.0 }
    end

    context "jd" do
      it { expect(sm.instance_variable_get(:@jd)).to eq 2457549.125 }
    end

    context "jd_jst" do
      it { expect(sm.instance_variable_get(:@jd_jst)).to eq 2457549.5 }
    end

    context "lat" do
      it { expect(sm.instance_variable_get(:@lat)).to be_within(1.0e-8).of(35.47222222) }
    end

    context "lon" do
      it { expect(sm.instance_variable_get(:@lon)).to be_within(1.0e-8).of(133.05055556) }
    end

    context "alt" do
      it { expect(sm.instance_variable_get(:@alt)).to eq 0.0 }
    end

    context "dt" do
      it { expect(sm.instance_variable_get(:@dt)).to be_within(1.0e-3).of(68.184) }
    end

    context "incl" do
      it { expect(sm.instance_variable_get(:@incl)).to eq 0.0 }
    end
  end

  context "#sunrise" do
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.sunrise }
    it { expect(subject).to match(["04:51:58", be_within(0.01).of(60.62)]) }
  end

  context "#sunset" do
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.sunset }
    it { expect(subject).to match(["19:22:41", be_within(0.01).of(299.44)]) }
  end

  context "#sun_mp" do  # mp = meridian passage (= sm.lmination)
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.sun_mp }
    it { expect(subject).to match(["12:07:15", be_within(0.01).of(77.57)]) }
  end

  context "#moonrise (1)" do
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.moonrise }
    it { expect(subject).to match(["09:59:25", be_within(0.01).of(75.64)]) }
  end

  context "#moonrise (2)" do
    let(:sm) { described_class.new([2016, 6, 27, 35.47222222, 133.05055556, 0]) }
    subject { sm.moonrise }
    it { expect(subject).to match(["--:--:--", "---"]) }
  end

  context "#moonset (1)" do
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.moonset }
    it { expect(subject).to match(["23:25:03", be_within(0.01).of(282.07)]) }
  end

  context "#moonset (2)" do
    let(:sm) { described_class.new([2016, 6, 12, 35.47222222, 133.05055556, 0]) }
    subject { sm.moonset }
    it { expect(subject).to match(["--:--:--", "---"]) }
  end

  context "#moon_mp (1)" do  # mp = meridian passage (= sm.lmination)
    let(:sm) { described_class.new([2016, 6, 10, 35.47222222, 133.05055556, 0]) }
    subject { sm.moon_mp }
    it { expect(subject).to match(["16:45:10", be_within(0.01).of(65.48)]) }
  end

  context "#moon_mp (2)" do  # mp = meridian passage (= sm.lmination)
    let(:sm) { described_class.new([2016, 6, 20, 35.47222222, 133.05055556, 0]) }
    subject { sm.moon_mp }
    it { expect(subject).to match(["--:--:--", "---"]) }
  end
end

