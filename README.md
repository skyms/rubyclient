# O365rubylib

This Ruby Gem is intended for Ruby web application developers to access Office 365 Services, which includes OneDrive for Business, Outlook, etc. This initial version targets subset of v1.0 OneDrive Business Files APIs. 
The details of the Office 365 REST APIs can be found at http://dev.office.com under documentation section. 

This library is will evolve over time. We encourage developer community engagement and feedback to improve the quality and enhance the features. 

## Pre-requisites 

In order to use the SDK against Office 365 service the developer will need a Office 365 tenant and Azure account that is linked to Office 365 tenant. 

This allows App registration and configuration, which is a key input into creating a client. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'o365rubylib'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install o365rubylib

In your Application require o365rubylib

## Setup
```ruby
require 'o365rubylib'
```

## Usage

### Authentication 
This library supports Oauth2 protocol. The first step is to supply the following application configuration required to create a session.
1. Client Id 
2. Secret 
3. Reply URL(s) 
todo: The Office 365 discovery service needs to be incorporated. Until that time the resource URL needs to be supplied as an input. 

To create a Session object, supply the input configuration details.

```ruby
APP_CONFIG = {
    client_id: "32ea5265-35bc-49c7-bf03-fa7928bc07dc",
    redirect_uri: "http://localhost:4567/go",
    secret: "C+WTbpXIt26drLsv3lXY/qyOQn6hPfGcLHo8IYnHO1Q=",
    resource_uri: "https://<tenant-name>-my.sharepoint.com/",
    fileservice_uri: "https://<tenant-name>-my.sharepoint.com/_api/v1.0/me/"
	}
```

Next, create a session by passing the configuration information to the session object.
```ruby
session = O365rubylib::Session.new (APP_CONFIG)
```
When the user visits your application, ensure that you have the required consent. You can redirect the user to Azure authentication service and have them consent the necessary permissions needed by your App.

You can create an authorization URL as follows
```ruby
auth_url = session.get_auth_url
```
After consent, Azure will redirect to the URL supplied in the "redirect_uri". In that page/service, create the Oauth2 access token OneDrive Files client.
```ruby
accesstoken = session.get_access_token(params[:code])	
fileClient = O365rubylib::OneDriveClient.new (session)
```
Now armed with the client, you can access O365 Files APIs. 

```ruby
accesstoken = session.get_access_token(params[:code])	
fileClient = O365rubylib::OneDriveClient.new (session)
```

### APIs 

Get File or Folder metadata. You'll receive a hash of the item:
```ruby
enc_path = URI::encode('resource-path')
item = fileClient.getItemByPath(enc_path)
print item ['name']
```

List the children of a folder:
```ruby
enc_path = URI::encode('resource-path')
resp = fileClient.getChildrenByPath(enc_path)
resphash = resp["value"]
resphash.each do |arr|
		print arr['name']
        print arr['parentReference']['path']
        ...
end
```

Delete a resource:
```ruby
enc_path = URI::encode('resource-path')
fileClient.deleteItem(enc_path)    
```

Download a file to a local destination: 
```ruby
enc_path = URI::encode('resource-path')
fileClient.downloadFile(enc_path, local_path) 
```

Upload a file:
```ruby
enc_path = URI::encode('resource-path')
fileClient.uploadFileToPath(enc_path, local_path) 
```

More coming...

## Contributing

1. Fork it ( https://github.com/[my-github-username]/o365rubylib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request