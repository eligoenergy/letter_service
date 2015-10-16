
require 'letter_service'

require 'vcr'

RSpec.configure do |config|

  VCR.configure do |config|
    config.cassette_library_dir = "spec/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
  end

  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    FactoryGirl.lint
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end
