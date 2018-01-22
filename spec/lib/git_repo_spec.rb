# frozen_string_literal: true
require "spec_helper"

describe GitRepo do
  before         { stub_const "CONFIG", {"save_game" => {"repo" => "abc"}} }
  let(:fake_git) { double Git }

  it "delegates everything over" do
    expect(Git).to receive(:open).with("abc").and_return fake_git
    expect(fake_git).to receive(:checkout)
    expect(fake_git).to receive(:log)
    expect(fake_git).to receive(:dir)

    GitRepo.checkout "foo"
    GitRepo.log
    GitRepo.dir
  end
end
