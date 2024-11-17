require "spec_helper"

RSpec.describe Yayaml::Handler do
  it "calls on_node for terminal nodes" do
    yaml = <<~YAML
      ---
      abc:
        ghj: 123
        xyz: 234
    YAML

    matcher = Yayaml::Matcher.new("123")
    allow(matcher).to receive(:on_node).and_call_original
    handler = Yayaml::Handler.new(matcher, filename: "example.yml")

    expect { Psych::Parser.new(handler).parse(yaml) }.to output.to_stdout

    expect(matcher).to have_received(:on_node).with(["abc", "ghj"], "123", "example.yml", 3)
    expect(matcher).to have_received(:on_node).with(["abc", "xyz"], "234", "example.yml", 4)
  end
end
