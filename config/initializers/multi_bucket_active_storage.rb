# frozen_string_literal: true

module Methods
  def set_bucket(municipality)
    return if municipality.blank?
    return unless municipality.minio_config_valid?

    @bucket = get_bucket_obj(municipality)
  end

  def get_bucket_obj(municipality)
    access_key_id = municipality.settings[:minio_access_key]
    secret_access_key = municipality.settings[:minio_secret_key]
    bucket_name = municipality.settings[:minio_bucket]
    region = municipality.settings[:minio_region]
    endpoint = municipality.settings[:minio_endpoint]

    s3 = Aws::S3::Resource.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      endpoint: endpoint,
      region: region,
      force_path_style: true
    )
    return s3.bucket(bucket_name)
  end
end

ActiveStorage::Service.module_eval { attr_writer :bucket }
ActiveStorage::Service.class_eval { include Methods }
