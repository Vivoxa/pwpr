require 'selenium-webdriver'
require 'capybara-screenshot/rspec'

Capybara.app_host = ENV.fetch('APP_HOST')
Capybara.save_path = '/desktop/screenshots'
Capybara.run_server = false # don't start Rack
Capybara.default_driver = :selenium
Capybara.default_max_wait_time = 15
Capybara.always_include_port = true

  Capybara.configure do |config|
    config.register_driver :selenium_hub do |app|
      browser = ENV.fetch('BROWSER').downcase
      puts "Using browser: #{browser}"
      capabilities = Selenium::WebDriver::Remote::Capabilities.public_send(browser.to_sym)
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV.fetch('SELENIUM_HUB_URL'),
        desired_capabilities: capabilities)
    end
    config.default_driver = :selenium_hub
    config.javascript_driver = :selenium_hub

    Capybara::Screenshot.register_driver(:selenium_hub) do |driver, path|
      driver.browser.save_screenshot(path)
    end

  RSpec.configure do |config|
    config.include Capybara::DSL

    config.around(:all) do |example|
      @_session = Capybara::Session.new(:selenium_hub)
      example.run
#      @_session.driver.browser.quit
    end
  end
end
