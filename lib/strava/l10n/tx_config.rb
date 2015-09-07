require 'parseconfig'
require 'strava/l10n/tx_resource'
require 'logger'

module Strava
  module L10n
    class TxConfig


      def initialize(path)
        config = ParseConfig.new(path)
        @resources = []
        config.get_groups().each do |group|
          if group == 'main'
            main = config[group]
            @lang_map = {}
            if main['lang_map']
                @lang_map = Strava::L10n::TxConfig.parse_lang_map(main['lang_map'])
            end
          else
            @resources.push(Strava::L10n::TxConfig.parse_resource(group, config[group]))
          end
        end
      end

      def self.parse_lang_map(lang_map)
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        lang_map.split(',').inject({}) do |result, m|
          key_value = m.split(':', 2)
          kvk = key_value[0].strip
          kvv = key_value[1].strip
          logger.debug("Lang key: #{kvk}, value #{kvv}");
          result[kvk] = kvv
          result
        end
      end

      def self.parse_resource(name, resource)
        id = name.split('.', 2)
        TxResource.new(id[0].strip, id[1].strip, resource['type'],
                       resource['source_lang'],
                       resource['source_file'], resource['file_filter'])
      end

      def resources
        @resources
      end

      def lang_map
        @lang_map
      end
    end
  end
end
