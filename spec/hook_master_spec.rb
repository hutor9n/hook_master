# spec/hook_master_spec.rb
require "hook_master/runner"

RSpec.describe HookMaster do
  it "has a version number" do
    expect(HookMaster::VERSION).not_to be nil
  end
end

RSpec.describe HookMaster::Runner do
  describe ".run_rubocop" do
    it "calls the 'rubocop' system command" do
      expect(HookMaster::Runner).to receive(:system).with("rubocop --format p").and_return(true)
      allow($?).to receive(:success?).and_return(true) 
      
      HookMaster::Runner.send(:run_rubocop)
    end
  end
end
