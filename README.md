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

- **batch_size** (integer) (optional): The maximum number of files processed in each run.
  - Default value: `10`.
- **content_key** (string) (optional): The field where the content of the file is stored in the output event.
  - Default value: `content`.
- **filename_key** (string) (optional): The field where the name of the file is stored in the output event.
  - Default value: `filename`.
- **path** (string) (required): The path of the folder to scan.
- **run_interval** (integer) (optional): The interval (in seconds) to wait between scans.
  - Default value: `60`.
- **tag** (string) (required): The tag added to the output event.

## Copyright

- Copyright(c) 2021- Rémy DUTHU
- License
  - Apache License, Version 2.0
