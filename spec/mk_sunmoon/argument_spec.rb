require "spec_helper"
require "date"

describe MkSunmoon::Argument do
  context "#self.new(\"20160610\", \"35.47222222\", \"133.05055556\", \"0\")" do
    let(:a) { described_class.new("20160610", "35.47222222", "133.05055556", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([
        2016, 6, 10,
        be_within(1.0e-8).of(35.47222222),
        be_within(1.0e-8).of(133.05055556),
        0.0
      ]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to match([2016, 6, 10]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(35.47222222) }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(133.05055556) }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end

  context "#self.new(\"20160610\", \"-45.2\", \"-173.6\", \"0\")" do
    let(:a) { described_class.new("20160610", "-45.2", "-173.6", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([2016, 6, 10, -45.2, -173.6, 0.0]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to match([2016, 6, 10]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to eq -45.2 }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to eq -173.6 }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end

  context "#self.new(\"20160610X\", \"35.47222222\", \"133.05055556\", \"0\")" do
    let(:a) { described_class.new("20160610X", "35.47222222", "133.05055556", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to be_nil }
    end
  end

  context "#self.new(\"20160631\", \"35.47222222\", \"133.05055556\", \"0\")" do
    let(:a) { described_class.new("20160631", "35.47222222", "133.05055556", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to be_nil }
    end
  end

  context "#self.new(\"20160610\", \"135.47222222\", \"133.05055556\", \"0\")" do
    let(:a) { described_class.new("20160610", "135.47222222", "133.05055556", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([]) }
    end

    context "get_latitude" do
      subject { a.send(:get_latitude) }
      it { expect(subject).to be_nil }
    end
  end

  context "#self.new(\"20160610\", \"35.47222222\", \"233.05055556\", \"0\")" do
    let(:a) { described_class.new("20160610", "35.47222222", "233.05055556", "0") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([]) }
    end

    context "get_longitude" do
      subject { a.send(:get_longitude) }
      it { expect(subject).to be_nil }
    end
  end

  context "#self.new(\"20160610\", \"35.47222222\", \"133.05055556\", \"10000\")" do
    let(:a) { described_class.new("20160610", "35.47222222", "133.05055556", "10000") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([]) }
    end

    context "get_altitude" do
      subject { a.send(:get_altitude) }
      it { expect(subject).to be_nil }
    end
  end

  context "#self.new(\"20160610\", \"35.47222222\", \"133.05055556\")" do
    let(:a) { described_class.new("20160610", "35.47222222", "133.05055556") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([
        2016, 6, 10,
        be_within(1.0e-8).of(35.47222222),
        be_within(1.0e-8).of(133.05055556),
        0.0
      ]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to match([2016, 6, 10]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(35.47222222) }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(133.05055556) }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end

  context "#self.new(\"20160610\", \"35.47222222\")" do
    let(:a) { described_class.new("20160610", "35.47222222") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([
        2016, 6, 10,
        be_within(1.0e-8).of(35.47222222),
        be_within(1.0e-8).of(133.05055556),
        0.0
      ]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to match([2016, 6, 10]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(35.47222222) }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(133.05055556) }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end

  context "#self.new(\"20160610\")" do
    let(:a) { described_class.new("20160610") }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      subject { a.get_args }
      it { expect(subject).to match([
        2016, 6, 10,
        be_within(1.0e-8).of(35.47222222),
        be_within(1.0e-8).of(133.05055556),
        0.0
      ]) }
    end

    context "get_date" do
      subject { a.send(:get_date) }
      it { expect(subject).to match([2016, 6, 10]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(35.47222222) }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(133.05055556) }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end

  context "#self.new" do
    let(:a) { described_class.new }

    context "object" do
      it { expect(a).to be_an_instance_of(MkSunmoon::Argument) }
    end

    context "get_args" do
      let(:y) { Time.now.year }
      let(:m) { Time.now.month }
      let(:d) { Time.now.day }
      subject { a.get_args }
      it { expect(subject).to match([
        y, m, d,
        be_within(1.0e-8).of(35.47222222),
        be_within(1.0e-8).of(133.05055556),
        0.0
      ]) }
    end

    context "get_date" do
      let(:y) { Time.now.year }
      let(:m) { Time.now.month }
      let(:d) { Time.now.day }
      subject { a.send(:get_date) }
      it { expect(subject).to match([y, m, d]) }
    end

    context "get_latitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(35.47222222) }
    end

    context "get_longitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
      end
      it { expect(subject).to be_within(1.0e-8).of(133.05055556) }
    end

    context "get_altitude" do
      subject do
        a.send(:get_date)
        a.send(:get_latitude)
        a.send(:get_longitude)
        a.send(:get_altitude)
      end
      it { expect(subject).to eq 0.0 }
    end
  end
end

