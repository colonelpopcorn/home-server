# Vagrant, man...
Derping on how to get inventory to not suck on windows with ansible_local...

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

[This looks so much yummier than whatever I've got going rn](https://stackoverflow.com/a/42462846)