#
# Copyright 2021- TODO: Write your name
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fluent/plugin/input'

module Fluent
  module Plugin
    class DirectoryInput < Fluent::Plugin::Input
      Fluent::Plugin.register_input('directory', self)

      desc 'The name of the key whose value is the content of the file.'
      config_param :content_key, :string, default: 'content'

      desc 'The extension that will be added to the processed files.'
      config_param :extension, :string, default: '.done'

      desc 'The name of the key whose value is the name of the file.'
      config_param :filename_key, :string, default: 'filename'

      desc 'The path of the folder to be scanned by the plugin.'
      config_param :path, :string

      desc 'The time interval (in seconds) to wait between scans.'
      config_param :run_interval, :integer, default: 60

      desc 'The tag added to the output event.'
      config_param :tag, :string

      def start
        super

        begin
          # Scan files indefinitely
          loop do
            # Use a stream to submit multiple events at the same time
            multiEventStream = MultiEventStream.new

            # Use the current time as the event time
            time = Fluent::Engine.now

            # Read filenames in the directory
            Dir.glob(@path + '/*') do |filename|
              # Ignore already processed files
              next if filename.end_with? @extension

              # Add the record to the stream
              multiEventStream.add(
                time,
                { @content_key => File.read(filename), @file_key => filename }
              )

              # Mark the file as processed
              File.rename(filename, filename + @extension)
            end

            # Send the events
            router.emit_stream(tag, multiEventStream)

            # Wait before the next scan
            sleep(@run_interval)
          end
        rescue Exception => e
          $log.warn 'Directory input error: ', e
          $log.debug_backtrace(e.backtrace)
        end
      end
    end
  end
end
