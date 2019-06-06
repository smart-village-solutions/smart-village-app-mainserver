class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_checksum(fields)
    Digest::MD5.hexdigest(fields.sort.join.to_s)
  end
end
