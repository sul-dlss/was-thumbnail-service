# frozen_string_literal: true

json.thumbnails @memento_records do |memento|
  json.memento_uri memento.memento_uri
  json.memento_datetime Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s)
  json.thumbnail_uri build_thumbnail_uri(@druid_id.sub('druid:', ''), Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s), @thumb_size)
  json.iiif_json_uri build_iiif_json_uri(@druid_id.sub('druid:', ''), Was::ThumbnailService::Utilities.convert_date_to_14_digits(memento['memento_datetime'].to_s))
end
