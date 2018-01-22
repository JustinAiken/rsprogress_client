# frozen_string_literal: true
require "spec_helper"

describe ProgressSaver, :stubbed_client do
  let(:saver)   { described_class.new }
  let(:profile) { double ProfileBackup }

  describe "save!" do
    it "saves" do
      expect(client).to receive(:profile).and_return steam_mins: 123
      expect(ProfileBackup).to receive(:new).and_return profile
      expect(profile).to receive :copy_to_repo!
      expect(profile).to receive :stage!
      expect(profile).to receive(:commit!).with minutes_played: 123

      saver.save!
    end
  end
end
