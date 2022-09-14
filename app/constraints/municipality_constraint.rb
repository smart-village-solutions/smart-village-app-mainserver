# frozen_string_literal: true

class MunicipalityConstraint
  def self.authorized?(request)
    municipality_service = MunicipalityService.new(subdomains: request.subdomains)
    current_municipality = municipality_service.municipality if municipality_service.subdomain_valid?
    MunicipalityService.municipality_id = current_municipality.id if current_municipality.present?

    user = request.env["warden"].user(:user)
    user.present?
  end
end
