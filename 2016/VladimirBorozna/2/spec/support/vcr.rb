VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/incoming_requests"
  config.hook_into :webmock
  config.filter_sensitive_data("<TELEGRAM_BOT_TOKEN>") do
    Bot.configuration.bot_token
  end
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description]
                    .split(/\s+/, 2)
                    .join("/")
                    .tr(".", "/")
                    .gsub(/[^\w\/]+/, "_")
                    .gsub(/\/$/, "")
                    .downcase

      VCR.use_cassette(name, options, &example)
    end
  end
end
