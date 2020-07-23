require 'rubygems'
require 'rest-client'
require 'json'

user = ENV["BROWSERSTACK_USER"]
key = ENV["BROWSERSTACK_ACCESSKEY"]

# API base URL
	base_url = "https://#{user}:#{key}@api.browserstack.com/app-automate/"



# Upload App
	results = RestClient.post(
		base_url + "upload",
		file: File.new("./app/apps/XCUITest-App.ipa", 'rb')
	)
	app_url = JSON.parse(results.body)['app_url']



# Upload Tests
	results = RestClient.post(
		base_url + "xcuitest/test-suite",
		file: File.new("./app/apps/XCUITest-AppTest.zip", 'rb')
	)
	test_url = JSON.parse(results.body)['test_url']



# Execute Tests
	RestClient.post(
		base_url + "xcuitest/build",
		{ 
			"app": app_url, 
			"testSuite": test_url,
			"devices": [
				"iPhone 7 Plus-10.3",
				"iPhone 8-11.0"
			], 
			"deviceLogs": true 
		}.to_json,
		content_type: :json
	)


