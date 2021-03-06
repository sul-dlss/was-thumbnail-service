# frozen_string_literal: true

module Was
  module ThumbnailService
    module Synchronization
      # It responsible of reading the timemap from the database.
      class TimemapDatabaseParser
        def initialize(uri)
          @uri = uri
        end

        def timemap
          memento_hash_list = {}

          memento_records = Memento.memento_records(@uri)
          memento_records.each do |memento_record|
            next unless memento_record[:memento_uri].present? && memento_record[:memento_datetime].present?
            memento_datetime = Utilities.convert_date_to_14_digits(memento_record[:memento_datetime].to_s)
            memento_hash_list[memento_datetime] = memento_record[:memento_uri]
          end
          memento_hash_list
        end
      end
    end
  end
end
