class LanguageService
  def self.languages
    static_content = StaticContent.where(name: "languages", data_type: "json").first.try(:content)
    return ["de"] if static_content.blank?

    begin
      JSON.parse(static_content)
    rescue
      ["de"]
    end
  end
end
