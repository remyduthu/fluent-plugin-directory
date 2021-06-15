# fluent-plugin-directory

[Fluentd](https://fluentd.org/) input plugin to scan files recurrently from a directory.

## Installation

### RubyGems

```
$ gem install fluent-plugin-directory
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-directory"
```

And then execute:

```
$ bundle
```

## Configuration

### content_key (string) (optional)

The name of the key whose value is the content of the file.

Default value: `content`.

### extension (string) (optional)

The extension that will be added to the processed files.

Default value: `.done`.

### filename_key (string) (optional)

The name of the key whose value is the name of the file.

Default value: `filename`.

### path (string) (required)

The path of the folder to be scanned by the plugin.

### run_interval (integer) (optional)

The time interval (in seconds) to wait between scans.

Default value: `60`.

### tag (string) (required)

The tag added to the output event.

- See also: [Input Plugin Overview](https://docs.fluentd.org/v/1.0/input#overview)

## Copyright

- Copyright(c) 2021- TODO: Write your name
- License
  - Apache License, Version 2.0
