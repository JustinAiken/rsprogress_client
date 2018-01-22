require_relative "../boot"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec

  RSpec.shared_context stubbed_client: true do
    let(:client) { double ProgressClient }
    before       { allow(ProgressClient).to receive(:client).and_return client }
  end
end
