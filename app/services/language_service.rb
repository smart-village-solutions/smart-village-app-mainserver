# frozen_string_literal: true

class LanguageService
  def self.languages
    static_content = StaticContent.where(name: "languages", data_type: "json").first.try(:content)
    fallback_language = "de"
    return [fallback_language] if static_content.blank?

    begin
      JSON.parse(static_content)
    rescue
      [fallback_language]
    end
  end
end
