# frozen_string_literal: true

class MinioService

  def initialize(endpoint:, access_key:, secret_key:, region:)
    @endpoint = endpoint
    @access_key = access_key
    @secret_key = secret_key
    @region = region
  end

  def create_bucket(bucket_name)
    return true if bucket_exists?(bucket_name)

    aws_client.create_bucket(bucket: bucket_name)
    set_bucket_policy(bucket_name)
  end

  def set_bucket_policy(bucket_name)
    policy = {
      "Version" => "2012-10-17",
      "Statement" => [
        {
          "Effect" => "Allow",
          "Principal" => { "AWS" => "*" },
          "Action" => [
            "s3:GetBucketLocation",
            "s3:ListBucket"
          ],
          "Resource" => "arn:aws:s3:::#{bucket_name}"
        },
        {
          "Effect" => "Allow",
          "Principal" => { "AWS" => "*" },
          "Action" => "s3:GetObject",
          "Resource" => "arn:aws:s3:::#{bucket_name}/*"
        }
      ]
    }

    aws_client.put_bucket_policy({
      bucket: bucket_name,
      policy: policy.to_json
    })
  end

  def get_bucket_policy(bucket_name)
    response = aws_client.get_bucket_policy(bucket: bucket_name)
    JSON.parse(response.policy.string)
  rescue Aws::S3::Errors::NoSuchBucketPolicy
    "Keine Policy gefunden"
  end

  def bucket_exists?(bucket_name)
    aws_client.list_buckets["buckets"].map(&:name).include?(bucket_name)
  end

  def aws_client
    Aws.config.update(
      endpoint: @endpoint,
      access_key_id: @access_key,
      secret_access_key: @secret_key,
      force_path_style: true,
      region: @region
    )
    Aws::S3::Client.new
  end
end
