```ruby
config.trigger.before :all do |trigger|
  if Vagrant::Util::Platform.windows?
    write_winventory(hosts_map)
  end
end

def write_winventory(hosts_map)
  puts("Hello world!")
end
```