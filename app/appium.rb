require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'appium_lib'
require 'browserstack/local'

class AndroidAppTest < Test::Unit::TestCase

# curl -u "<user>:<key>" 
# 		 -X POST "https://api.browserstack.com/app-automate/upload" 
# 		 -F "file=@/Path/to/File/WikipediaSample.apk"

  def setup
    caps = {}
		caps['device'] = 'Google Pixel'
		caps['realMobile'] = true
		caps['app'] = 'DemoApp'

		caps['project'] = "BrowserStack"
		caps['build'] = "Demo"
		caps['name'] = "Wikipedia Search Function"

		caps['browserstack.debug'] = true
    
		appium_driver = Appium::Driver.new({
			'caps' => caps,
			'appium_lib' => {
				:server_url => "http://#{ENV["BROWSERSTACK_USER"]}:#{ENV["BROWSERSTACK_ACCESSKEY"]}@hub-cloud.browserstack.com/wd/hub"
			}}, true)
		@driver = appium_driver.start_driver
		
  end

  def test_post
	  wait = Selenium::WebDriver::Wait.new(:timeout => 30)
		wait.until { @driver.find_element(:accessibility_id, "Search Wikipedia").displayed? }
		element = @driver.find_element(:accessibility_id, "Search Wikipedia")
		element.click

		wait.until { @driver.find_element(:id, "org.wikipedia.alpha:id/search_src_text").displayed? }
		search_box = @driver.find_element(:id, "org.wikipedia.alpha:id/search_src_text")
		search_box.send_keys("BrowserStack")

		wait.until { @driver.find_element(:class, "android.widget.TextView").displayed? }
		results = @driver.find_elements(:class, "android.widget.TextView")

		results_count = results.count

		assert_equal(results_count, results_count)
  end

  def teardown
    @driver.quit
  end
  
end
