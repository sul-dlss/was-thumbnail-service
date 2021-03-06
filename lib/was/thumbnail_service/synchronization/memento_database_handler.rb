# frozen_string_literal: true

module Was
  module ThumbnailService
    module Synchronization
      class MementoDatabaseHandler
        def initialize(uri_id, memento_uri, memento_datetime)
          @uri_id = uri_id
          @memento_uri = memento_uri
          @memento_datetime = memento_datetime
        end

        def add_memento_to_database_timemap
          memento_text = download_memento_text
          @simhash_value = compute_simhash_value(memento_text)
          insert_memento_into_database
        end

        def insert_memento_into_database
          unless @uri_id.present? && @memento_uri.present? && @memento_datetime.present? &&
                 !@simhash_value.nil? && @simhash_value.positive?

            raise 'Memento insert is missing required fields. ' \
                  "Uri-id: #{@uri_id}, Memento-uri: #{@memento_uri}, " \
                  "Memento-datetime: #{@memento_datetime}, Simhash_value: #{@simhash_value}"
          end

          memento = Memento.new
          memento[:uri_id] = @uri_id
          memento[:memento_uri] = @memento_uri
          memento[:memento_datetime] = @memento_datetime
          memento[:simhash_value] = @simhash_value
          memento[:is_selected] = 0
          memento[:is_thumbnail_captured] = 0
          memento.save
        end

        def compute_simhash_value(memento_text)
          if memento_text.present?
            memento_text.simhash(preserve_punctuation: true, stop_words: false)
          else
            0
          end
        end

        def download_memento_text
          return '' if @memento_uri.blank?
          datetime_path = @memento_uri.match(%r{/\d+{14}/}).to_s
          return '' if datetime_path.empty?

          # Insert id_ after the datetime part in the uri to avoid wayback rewriting page w its own header
          memento_uri_unwritten = @memento_uri.sub(datetime_path, datetime_path[0..-2] + 'id_/')
          begin
            response = Faraday.get(memento_uri_unwritten)
            raise "#{response.reason_phrase}: #{response.status}" unless response.success?
            response.body.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
            # NOTE:  if the url gives a 302 to the original, non-wayback url, then who is to say that page still is extant?
            #   and then the 302 becomes a 404, which blows up here.
          rescue StandardError => e
            raise "error downloading memento text from #{memento_uri_unwritten}.\n#{e.inspect}\nHTTP Response: #{e.message}\n#{e.backtrace.join(%(\n))}"
          end
        end
      end
    end
  end
end
