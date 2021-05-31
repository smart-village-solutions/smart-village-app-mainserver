class Settings
  def self.config
    current_community = ENV["SVA_COMMUNITY"].presence || "local-localhost"
    file_name = "releases/#{current_community}/credentials.yml"
    return {} unless File.exist?(file_name)

    @config ||= HashWithIndifferentAccess.new(
      YAML.safe_load(
        File.read(
          Rails.root.join(file_name)
        )
      )
    )
  end

  def self.method_missing(method_name)
    Settings.config[method_name.to_sym]
  end

end
