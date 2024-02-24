# Remind
GNU remind is a fantastic utility for managing schedules, tasks, events, and reminders.

## Installation

### Bundle
```
bundle add remind
```

### Gem
```
gem install remind
```

### Build
```
gem build remind.gemspec
```


## Usage
```
require 'remind'
```
### Remind
A wapper around gnu remind.

#### Set Reminders Collection
Create local reminders from url.
```
Remind.set(collection, "Binner at 8 tonight.")
```

#### Get Reminders Collection
Extract agenda from local reminders.
```
Remind.get(collection)
```

#### Get System Reminders
```
Remind.get!
```

## Development
You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.
