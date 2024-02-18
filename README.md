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
Use as a generic reminder handler.

#### set
Create local reminders from url.
```
Remind['key'] = %[https://example.ics]
```

#### get
Extract agenda from local reminders.
```
Remind['key']
```

#### all
```
Remind.all
```


### REM
Use as a task specific tool

#### collection
```
REM['collection']
```

#### entry
```
REM['collection']['entry']
```

#### entry attributes
```
REM['collection']['entry'].attr = { type: "event type", date: "1 Jan 1970", lead: 7, repeat: 4, hour: "22", minute: "45", duration: "1:45", at: "Place Name" }
```

#### entry reminder
```
REM['collection'].to_rem
```

#### save collection
```
REM['collection'].to_rem!
```

#### collection agenda
```
REM['collection'].agenda
```


## Development
You can also run `ruby bin/console` for an interactive prompt that will allow you to experiment.
