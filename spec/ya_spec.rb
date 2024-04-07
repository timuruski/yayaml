require "spec_helper"

RSpec.describe "bin/ya" do
  it "searches for YAML values for a pattern" do
    expect(`bin/ya Hello spec/fixtures`)
      .to eq(<<~EOS)
        spec/fixtures/en-US.yml:4 en-US.app.greeting: Hello, world!
      EOS
  end

  it "searches for YAML paths for a pattern" do
    expect(`bin/ya -p greeting spec/fixtures`)
      .to eq(<<~EOS)
        spec/fixtures/en-US.yml:4 en-US.app.greeting: Hello, world!
        spec/fixtures/fr-FR.yml:4 fr-FR.app.greeting: Bonjour le monde!
      EOS
  end
end
