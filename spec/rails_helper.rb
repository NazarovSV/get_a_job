# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'faker'
require 'pundit/rspec'
require 'aasm/rspec'
require 'validate_url/rspec_matcher'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FactoryBot::Syntax::Methods
  config.include FeatureHelpers, type: :feature

  Capybara.javascript_driver = :selenium_chrome_headless

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  Faker::Config.locale = 'ru'

  Pundit::Matchers.configure do |config|
    config.user_alias = :employer
  end

  Geocoder.configure(lookup: :test)
  Geocoder::Lookup::Test.add_stub('New York, NY', [
                                    {
                                      'coordinates' => [40.7143528, -74.0059731],
                                      'address' => 'New York, NY, USA',
                                      'state' => 'New York',
                                      'state_code' => 'NY',
                                      'city' => 'New York',
                                      'country' => 'United States',
                                      'country_code' => 'US'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Russia, Moscow, Klimentovskiy Pereulok, 65', [
                                    {
                                      'coordinates' => [0.01, 0.01],
                                      'address' => 'Russia, Moscow, Klimentovskiy Pereulok, 65',
                                      'city' => 'Moscow',
                                      'country' => 'Russia'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Ukraine, Kyiv', [
                                    {
                                      'coordinates' => [0.02, 0.02],
                                      'address' => 'Ukraine, Kyiv',
                                      'city' => 'Kyiv',
                                      'country' => 'Ukraine'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('UK, London', [
                                    {
                                      'coordinates' => [0.03, 0.03],
                                      'address' => 'UK, London',
                                      'city' => 'London',
                                      'country' => 'UK'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Russia, Moscow', [
                                    {
                                      'coordinates' => [0.04, 0.04],
                                      'address' => 'Russia, Moscow',
                                      'city' => 'Moscow',
                                      'country' => 'Russia'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Россия, Москва, улица Новый Арбат, 21с1', [
                                    {
                                      'coordinates' => [0.041, 0.041],
                                      'address' => 'Россия, Москва, улица Новый Арбат, 21с1',
                                      'city' => 'Moscow',
                                      'country' => 'Russia'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Россия, Москва, Новочерёмушкинская улица, 39к1', [
                                    {
                                      'coordinates' => [0.042, 0.042],
                                      'address' => 'Россия, Москва, Новочерёмушкинская улица, 39к1',
                                      'city' => 'Moscow',
                                      'country' => 'Russia'
                                    }
                                  ])
  Geocoder::Lookup::Test.add_stub('Россия, Москва, Нахимовский проспект, 31к2', [
                                    {
                                      'coordinates' => [0.043, 0.043],
                                      'address' => 'Россия, Москва, Нахимовский проспект, 31к2',
                                      'city' => 'Moscow',
                                      'country' => 'Russia'
                                    }
                                  ])
  Geocoder::Lookup::Test.set_default_stub([])
end
