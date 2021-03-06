require "helper"
require "fluent/plugin/in_directory.rb"

class DirectoryInputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::DirectoryInput).configure(conf)
  end
end
