#
# Copyright 2021- Rémy DUTHU
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

      helpers :timer

      desc 'The field where the content of the file is stored in the output event.'
      config_param :content_key, :string, default: 'content'

      desc 'The field where the name of the file is stored in the output event.'
      config_param :filename_key, :string, default: 'filename'

      desc 'The path of the folder to scan.'
      config_param :path, :string

      desc 'The interval (in seconds) to wait between scans.'
      config_param :run_interval, :integer, default: 60

      desc 'The tag added to the output event.'
      config_param :tag, :string

      def start
        super

        # See: https://docs.fluentd.org/plugin-helper-overview/api-plugin-helper-timer
        timer_execute(:directory_timer, @run_interval) do
          begin
            # Use a stream to submit multiple events at the same time
            multiEventStream = MultiEventStream.new

            # Use the current time as the event time
            time = Fluent::Engine.now

            # Read filenames in the directory
            Dir.glob(@path + '/*') do |filename|
              # Add the record to the stream
              multiEventStream.add(
                time,
                { @content_key => File.read(filename), @filename_key => filename },
              )

              # Remove the file
              File.delete(filename)
            end

            # Send the events
            router.emit_stream(tag, multiEventStream)
          rescue StandardError
            yield(nil, nil)
          end
        end
      end
    end
  end
end
