# frozen_string_literal: true

namespace :cleanup do
  desc "Cleanup orphaned Blobs and their associated files in S3."
  task assets: :environment do
    # Fix Operation on given bucket name
    only_bucket_name = ENV['ONLY_IN_BUCKET']
    puts "Only delete in: #{only_bucket_name}" if only_bucket_name.present?

    # Find all blobs that do not have associated attachments
    orphaned_blobs = ActiveStorage::Blob.left_outer_joins(:attachments).where(active_storage_attachments: { id: nil })

    puts "Gefunden #{orphaned_blobs.count} verwaiste Blobs."

    # Durchlaufe alle verwaisten Blobs und lösche sie
    orphaned_blobs.find_each do |blob|
      # Durchlaufe alle Gemeinden und versuche die Datei im S3 im richtigen Bucket zu finden
      Municipality.all.each do |municipality|
        bucket_name = municipality.settings[:minio_bucket]
        # springe zum nächsten Bucket wenn kein Bucket definiert ist
        next if bucket_name.blank?

        # skip if only_bucket_name is set and does not match the current bucket
        next unless bucket_name == only_bucket_name if only_bucket_name.present?

        # Setze den Bucket für den aktuellen Durchlauf für den AWS S3 Service
        s3_service = ActiveStorage::Blob.service
        s3_service.set_bucket(municipality)

        # gehe zum nächsten Bucket wenn beim setzen des Buckets ein Fehler aufgetreten ist
        next unless s3_service.bucket.name == bucket_name

        # Versuche die Datei im S3 direkt zu finden
        begin
          s3_data = blob.service.bucket.client.get_object(bucket: bucket_name, key: blob.key)
        rescue Aws::S3::Errors::NoSuchKey
          s3_data = nil
        end

        # springe zum nächsten Bucket wenn in diesem keine passende Daten gefunden wurden
        next if s3_data.blank?

        # gehe zum nächsten Bucket wenn die gefundene Datei nicht die richtige Größe hatte
        next unless blob.byte_size == s3_data.content_length

        # Lösche den Blob und die zugehörige Datei im S3
        blob.purge
        puts "Blob #{blob.id} und zugehörige Datei im S3 gelöscht."

        # Springe zur nächsten Datei die gelöscht werden soll
        break
      end
    end
  end
end
