module RollbarInitializer
  extend ActiveSupport::Concern

  included do
    before_action :set_rollbar_access_token_and_payload_options
  end

  private

  def set_rollbar_access_token_and_payload_options
    Rollbar.configuration.access_token = MunicipalityService.settings[:rollbar_access_token]
    Rollbar.configuration.payload_options = {
      municipality_id: MunicipalityService.municipality_id,
      minio_bucket: MunicipalityService.settings[:minio_bucket]
    }

    ## This only working for Rollbar.log, Rollbar.error, etc. 
    # Rollbar.configuration.custom_data_method = lambda {
    #   {
    #     municipality_id: MunicipalityService.municipality_id,
    #     minio_bucket: MunicipalityService.settings[:minio_bucket]
    #   }
    # } 

  end
end
