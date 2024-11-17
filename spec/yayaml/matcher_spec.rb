require "spec_helper"

RSpec.describe Yayaml::Matcher do
  it "matches the value" do
    subject = described_class.new("bar")
    expect { subject.on_node(["foo"], "bar", "example.yml", 1) }
      .to output("example.yml:1 foo: bar\n").to_stdout
  end

  it "matches the path" do
    subject = described_class.new("foo", match_path: true)
    expect { subject.on_node(["foo"], "bar", "example.yml", 1) }
      .to output("example.yml:1 foo: bar\n").to_stdout
  end
end
