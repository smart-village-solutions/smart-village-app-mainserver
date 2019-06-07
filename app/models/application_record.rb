class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_checksum(fields)
    Digest::MD5.hexdigest(fields.map(&:to_s).sort.join.to_s)
  end
end
