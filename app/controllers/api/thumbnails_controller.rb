module Api
  class ThumbnailsController < ApplicationController
    before_filter :find_uri, only: [:list]
    respond_to :json

    def list
      uri_id = @seed_uri[:id]
      @druid_id = @seed_uri[:druid_id]
      @memento_records = Memento.where( "uri_id = ? AND is_selected = 1 AND is_thumbnail_captured = 1", uri_id )
    end
  
  private 
    def find_uri
      if params[:druid_id].present? then
        @seed_uri = SeedUri.find_by(druid_id: params[:druid_id]) 
        render nothing: true, status: :not_found unless @seed_uri.present?
      elsif params[:uri].present? then
        @seed_uri = SeedUri.find_by(uri: params[:uri]) 
        render nothing: true, status: :not_found unless @seed_uri.present?
      else
        render nothing: true, status: :not_found 
      end
    end
  end
end