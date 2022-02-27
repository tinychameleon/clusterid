# ClusterID
TODO: Delete this and the text above, and describe your gem


## What's in the Box?
TODO: Write this.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clusterid'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install clusterid


## Usage
Create an intance of `ClusterId::V1::Generator` and then use the `generate` method to create `ClusterId::V1::Value` instances.

```ruby
generator = ClusterId::V1::Generator.new
id = generator.generate
```

This kind of quick usage will use the default byte generator, clock, and serialization classes. The default serialization
classes are null objects which will:

- return `nil` for deserializing any data centre, environment, or type ID
- serialize any value for data centre, environment, or type ID as `0`.

If you would like to take advantage of these custom attributes see the [Custom Attributes & Serialization section below](#custom-attributes--serialization).

### Values
The `ClusterId::V1::Value` objects that are created have a small API which allows read access to the individual components
which make up the byte string. For example, to access the byte string for storage:

```ruby
value = generator.generate
puts value.bytes
```

[See the API docs for the full method reference](https://tinychameleon.github.io/clusterid/ClusterId/V1/Value.html).

### Values are `Comparable`
The `ClusterId::V1::Value` class implements the `Comparable` interface, so you can sort them, check for equality, and use the typical comparison operators.

### Reconstituting `ClusterId::V1::Value` Objects
If you've saved the byte string from one of these objects somewhere, you can manually create it again if you have a `ClusterId::V1::Deserializer`
or a `ClusterId::V1::Generator`.

With a generator configured with the correct `Deserializer`, you can use the `from_byte_string` method:

```ruby
byte_string = "..." # From storage, perhaps.
generator = ... # Some existing generator with the correct configuration.
value = generator.from_byte_string(byte_string)
```

Without a generator, you need to provide the `Deserializer` instance yourself:

```ruby
byte_string = "..." # From storage, perhaps.
deserializer = ClusterId::V1::NullDeserializer.new
value = ClusterId::V1::Value.new(byte_string, deserializer)
```

### Custom Attributes & Serialization
You can create subclasses of `ClusterId::V1::Serializer` and `ClusterId::V1::Deserializer` to represent your custom values for data centre, environment, and type IDs.
The `Serializer` will need to accept your application's types for the custom attributes and return integer values, while the `Deserializer` should do the opposite.

You can use any type as long as you implement the serialization and deserialization steps. For example, here are two simple classes that use only `Symbols`.

```ruby
class ExampleDeserializer < ClusterId::V1::Deserializer
  def to_data_centre(i)
    return :north_america if i == 1
    :global
  end

  def to_environment(i)
    return :production if i == 3
    :non_production
  end

  def to_type_id(i)
    return :user if i == 1
    return :settings if i == 2
    :unknown
  end
end

class ExampleSerializer < ClusterId::V1::Serializer
  def from_data_centre(s)
    return 1 if s == :north_america
    2
  end

  def from_environment(s)
    return 3 if s == :production
    1
  end

  def from_type_id(s)
    return 1 if s == :user
    return 2 if s == :settings
    99
  end
end

# Then pass them to the Generator constructor
g = ClusterId::V1::Generator.new(serializer: ExampleSerializer.new, deserializer: ExampleDeserializer.new)
```

Once you've implemented these custom classes you can provide your custom attributes to the `generate` method:

```ruby
v = g.generate(data_centre: :north_america, environment: :production, type_id: :user)
puts v.type_id # Output: :user
```

#### NOTE
When you implement custom serialization classes you become responsible for ensuring the bit length requirements for each
attribute are correct. [See the API documentation for details](https://tinychameleon.github.io/clusterid/ClusterId/V1/Value.html).

### Custom Byte Generators
If you need to use a byte generator other than the default of `SecureRandom` you can implement your own.
The only requirement is to have a `bytes(n)` method which returns a byte string. For example:

```ruby
module GuaranteedRandom
  DICE_ROLL = [4].cycle

  def bytes(n)
    DICE_ROLL.take(n).pack("C")
  end
end
```

Once you have a custom byte generator you can provide it to the `ClusterId::V1::Generator` constructor:

```ruby
g = ClusterId::V1::Generator(byte_generator: GuaranteedRandom)
```

### Custom Clock
If you need to implement a custom clock for millisecond timestamps you can implement your own.
The only requirement is to have a `now_ms` method which returns the millisecond time as an `Integer`.
For example:

```ruby
module UltraAccurateClock
  def now_ms
    expensive_hardware.get_time_ms
  end
end
```

Once you have created a custom clock you can provide it to the `ClusterId::V1::Generator` constructor:

```ruby
g = ClusterId::V1::Generator(clock: UltraAccurateClock)
```


## Contributing

### Development
To get started development on this gem run the `bin/setup` command. This will install dependencies and run the tests and linting tasks to ensure everything is working.

For an interactive console with the gem loaded run `bin/console`.


### Testing
Use the `bundle exec rake test` command to run unit tests. To install the gem onto your local machine for general integration testing use `bundle exec rake install`.

To test the gem against each supported version of Ruby use `bin/test_versions`. This will create a Docker image for each version and run the tests and linting steps.


### Releasing
Do the following to release a new version of this gem:

- Update the version number in [lib/clusterid/version.rb](./lib/clusterid/version.rb)
- Ensure necessary documentation changes are complete
- Ensure changes are in the [CHANGELOG.md](./CHANGELOG.md)
- Create the new release using `bundle exec rake release`

After this is done the following side-effects should be visible:

- A new git tag for the version number should exist
- Commits for the new version should be pushed to GitHub
- The new gem should be available on [rubygems.org](https://rubygems.org).

Finally, update the documentation hosted on GitHub Pages:

- Check-out the `gh-pages` branch
- Merge `main` into the `gh-pages` branch
- Generate the documentation with `bundle exec rake yard`
- Commit the documentation on the `gh-pages` branch
- Push the new documentation so GitHub Pages can deploy it
