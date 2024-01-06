# History Client Usage

Please make sure to first read through the History service [usage guidelines](https://git-aws.internal.justin.tv/foundation/history-service/blob/master/doc/usage.md) before using this client.

### Add Audits
Instantiating an instance of the client can be done with a simple call:

```ruby
client = History::Client.new(endpoint: "<hostname>")
```

To then add an audit, you must first instantiate an audit and set the appropriate fields:

```ruby
change = History::ChangeSet.new(
  attribute: "login",
  old_value: "old_login",
  new_value: "new_login"
)

audit = History::Audit.new(
  action: "update",
  user_type: "twitch_user",
  user_id: "123",
  resource_type: "twitch_user",
  resource_id: "123",
  description: "lorem ipsum",
  created_at: Time.now.utc.round(3).iso8601(3),
  expiry: 31622400,
  changes: [change]
)
```

And finally make the call to add the audit to the service:

```ruby
client.add(audit)
```

### Search for Audits
Once again, begin by instantiating an instance of the client (if you have not done so already):

```ruby
client = History::Client.new(endpoint: "<hostname>")
```

To search for audits, you must first instantiate a `SearchParams` object and set the appropriate parameters:

```ruby
params = History::SearchParams.new(
  user_type: "twitch_user",
  resource_id: "123",
  attribute: "login"
)
```

And finally make the call to search for audits matching the parameters passed in, then print out the response objects:

```ruby
response = client.search(params)
response.each do |audit
  puts audit[:uuid]
end
```


