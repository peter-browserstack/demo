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
		file: File.new("./app/apps/Espresso-App.apk", 'rb')
	)
	app_url = JSON.parse(results.body)['app_url']



# Upload Tests
	results = RestClient.post(
		base_url + "espresso/test-suite",
		file: File.new("./app/apps/Espresso-AppTest.apk", 'rb'),
	)
	test_url = JSON.parse(results.body)['test_url']



# Execute Tests
	RestClient.post(
		base_url + "espresso/build",
		{ 
			"app": app_url, 
			"testSuite": test_url,
			"devices": [
				"Google Pixel-8.0", 
				"Google Pixel-7.1"
			], 
			"deviceLogs": true 
		}.to_json,
		content_type: :json
	)



