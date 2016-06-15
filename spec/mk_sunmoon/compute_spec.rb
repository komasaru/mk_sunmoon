require "spec_helper"

describe MkSunmoon::Compute do
  let(:c) { MkSunmoon::Compute }

  context "#gc2jd" do
    subject { c.gc2jd(2016, 6, 10) }
    it { expect(subject).to eq 2457549.125 }
  end

  context "#compute_dt (case: A.D.2012)" do
    subject { c.compute_dt(2012, 6, 1) }
    it { expect(subject).to be_within(1.0e-3).of(66.184) }
  end

  context "#compute_dt (case: A.D.2016)" do
    subject { c.compute_dt(2016, 6, 5) }
    it { expect(subject).to be_within(1.0e-3).of(68.184) }
  end

  context "#compute_dt (case: A.D.2030)" do
    subject { c.compute_dt(2030, 5, 21) }
    it { expect(subject).to be_within(1.0e-3).of(77.863) }
  end

  context "#compute_dt (case: A.D.1952)" do
    subject { c.compute_dt(1952, 6, 22) }
    it { expect(subject).to be_within(1.0e-3).of(30.050) }
  end

  context "#compute_dt (case: A.D.500)" do
    subject { c.compute_dt(500, 7, 25) }
    it { expect(subject).to be_within(1.0e-3).of(5704.674) }
  end

  context "#compute_sun (case: sunrise)" do
    subject do
      c.instance_variable_set(:@jd, 2457549.125)
      c.instance_variable_set(:@dt, 68.184)
      c.instance_variable_set(:@incl, 0.0)
      c.instance_variable_set(:@lat, 35.47222222)
      c.instance_variable_set(:@lon, 133.05055556)
      c.compute_sun(0)
    end
    it { expect(subject).to match(["04:51:58", be_within(0.01).of(60.62)]) }
  end

  context "#compute_sun (case: sunset)" do
    subject { c.compute_sun(1) }
    it { expect(subject).to match(["19:22:41", be_within(0.01).of(299.44)]) }
  end

  context "#compute_sun (case: sun_meridian_passage)" do
    subject { c.compute_sun(2) }
    it { expect(subject).to match(["12:07:15", be_within(0.01).of(77.57)]) }
  end

  context "#compute_moon (case: moonrise)" do
    subject { c.compute_moon(0) }
    it { expect(subject).to match(["09:59:25", be_within(0.01).of(75.64)]) }
  end

  context "#compute_moon (case: moonset)" do
    subject { c.compute_moon(1) }
    it { expect(subject).to match(["23:25:03", be_within(0.01).of(282.07)]) }
  end

  context "#compute_moon (case: moon_meridian_passage)" do
    subject { c.compute_moon(2) }
    it { expect(subject).to match(["16:45:10", be_within(0.01).of(65.48)]) }
  end

  context "#compute_time_sun (case: sunrise)" do
    subject { c.compute_time_sun(0) }
    it { expect(subject).to be_within(1.0e-8).of(0.20275217) }
  end

  context "#compute_time_sun (case: sunset)" do
    subject { c.compute_time_sun(1) }
    it { expect(subject).to be_within(1.0e-8).of(0.80742303) }
  end

  context "#compute_time_sun (case: sun_meridian_passage)" do
    subject { c.compute_time_sun(2) }
    it { expect(subject).to be_within(1.0e-8).of(0.50503168) }
  end

  context "#compute_time_moon (case: moonrise)" do
    subject { c.compute_time_moon(0) }
    it { expect(subject).to be_within(1.0e-8).of(0.41625750) }
  end

  context "#compute_time_moon (case: moonset)" do
    subject { c.compute_time_moon(1) }
    it { expect(subject).to be_within(1.0e-8).of(0.97572853) }
  end

  context "#compute_time_moon (case: moon_meridian_passage)" do
    subject { c.compute_time_moon(2) }
    it { expect(subject).to be_within(1.0e-8).of(0.69803258) }
  end

  context "#compute_lambda_sun" do
    subject { c.compute_lambda_sun(16.43895562311074) }  # 2016-06-10
    it { expect(subject).to be_within(1.0e-4).of(79.3877) }
  end

  context "#compute_dist_sun" do
    subject { c.compute_dist_sun(16.43976944330367) }
    it { expect(subject).to be_within(1.0e-8).of(1.01530092) }
  end

  context "#compute_lambda_moon" do
    subject { c.compute_lambda_moon(16.439540168844054) }
    it { expect(subject).to be_within(1.0e-4).of(143.2256) }
  end

  context "#compute_beta_moon" do
    subject { c.compute_beta_moon(16.441071917036545) }
    it { expect(subject).to be_within(1.0e-4).of(-1.4356) }
  end

  context "#compute_diff_moon" do
    subject { c.compute_diff_moon(16.43976944330367) }
    it { expect(subject).to be_within(1.0e-4).of(0.9399) }
  end

  context "#norm_angle" do
    subject { c.norm_angle(1051.4215) }
    it { expect(subject).to be_within(1.0e-4).of(331.4215) }
  end

  context "#eclip2equat" do
    subject { c.eclip2equat(16.43976944330367, 79.67194905233877, 0) }
    it { expect(subject).to match([
      be_within(1.0e-8).of(78.76591287),
      be_within(1.0e-8).of(23.03531650)
    ]) }
  end

  context "#compute_sidereal_time" do
    subject { c.compute_sidereal_time(16.43976944330367, 0.5) }
    it { expect(subject).to be_within(1.0e-8).of(76.95476067) }
  end

  context "#compute_hour_angle_diff" do
    subject { c.compute_hour_angle_diff(78.76591287455761, 23.035316498377977, 76.95476066937135, -0.8461203262456258, 0) }
    it { expect(subject).to be_within(1.0e-8).of(-107.01432659) }
  end

  context "#val2hhmmss" do
    subject { c.val2hhmmss(0.20275217453140162 * 24) }
    it { expect(subject).to eq "04:51:58" }
  end

  context "#compute_angle_ecliptic (case: Sun)" do
    subject { c.compute_angle_ecliptic(16.43895562311074, 0.20275217453140162, 79.38770038068358, 0) }
    it { expect(subject).to be_within(0.01).of(60.62) }
  end

  context "#compute_angle_equator" do
    subject { c.compute_angle_equator(16.43895562311074, 0.20275217453140162, 78.45801495682086, 23.012993031654478) }
    it { expect(subject).to be_within(0.01).of(60.62) }
  end

  context "#compute_height_ecliptic" do
    subject { c.compute_height_ecliptic(16.439783219296576, 0.5050316814077513, 79.67676047304937, 0) }
    it { expect(subject).to be_within(0.01).of(77.57) }
  end

  context "#compute_height_equator" do
    subject { c.compute_height_equator(16.439783219296576, 0.5050316814077513, 78.7711254750786, 23.035689235948652) }
    it { expect(subject).to be_within(0.01).of(77.57) }
  end
end
#
