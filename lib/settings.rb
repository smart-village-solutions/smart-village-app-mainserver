class Settings
  def self.config
    current_community = ENV["SVA_COMMUNITY"].presence || "local-localhost"

    HashWithIndifferentAccess.new(
      YAML.safe_load(
        File.read(
          Rails.root.join("releases/#{current_community}/credentials.yml")
        )
      )
    )
  end
end
