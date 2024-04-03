require "spec_helper"

RSpec.describe Yay::Handler do
  it "works" do
    yaml = <<~YAML
      abc:
        ghj: 123
        xyz: 234
    YAML

    matcher = Yay::Matcher.new("123")
    allow(matcher).to receive(:on_node).and_call_original
    handler = Yay::Handler.new(matcher, filename: "example.yml")

    Psych::Parser.new(handler).parse(yaml)

    expect(matcher).to have_received(:on_node).with(["abc", "ghj"], "123")
    expect(matcher).to have_received(:on_node).with(["abc", "xyz"], "234")
  end
end
