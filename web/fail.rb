require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'browserstack/local'
require 'rest-client'

class FailTest < Test::Unit::TestCase

  def setup
    caps = Selenium::WebDriver::Remote::Capabilities.new
		caps['browser'] = 'IE'
		caps['browser_version'] = '11.0'
		caps['os'] = 'Windows'
		caps['os_version'] = '10'

		caps['project'] = "BrowserStack"
		caps['build'] = "Demo"
		caps['name'] = "Failed Test"

		caps["browserstack.debug"] = "true"

    url = "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => caps)

  end

  def test_post
		@driver.navigate.to 'http://www.google.com'
		title = @driver.title
    assert_equal("Incorrect Page Title", title)
  end

  def teardown
    api_url = "https://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@www.browserstack.com/automate/sessions/#{@driver.session_id}.json"
  	RestClient.put api_url, {"status"=>"failed", "reason"=>"Wrong title"}, {:content_type => :json}
    @driver.quit
  end

end
