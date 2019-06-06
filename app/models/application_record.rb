class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_checksum(fields)
    Digest::MD5.hexdigest(fields.to_s.chars.sort.join)
  end
end
