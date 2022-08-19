# frozen_string_literal: true

# Controller Concern for Controllers that use municipality authorization,
module MunicipalityAuthorization
  extend ActiveSupport::Concern

  # request.subdomains beinhaltet die Liste der URL Subdomains,
  # bsp.: ["bad-belzig", "server"]
  # Auf diese Werte werden Prüfungen durchgeführt und ggf. eine
  # Exception geworfen.
  #
  # Ist die Subdomain valide, so wird eine passende Municipality
  # gesucht und in @municipality gespeichert.
  #
  def determine_municipality
    municipality_service = MunicipalityService.new(subdomains: request.subdomains)

    redirect_to("http://#{ADMIN_URL}/municipalities") and return if municipality_service.admin_domain?

    @current_municipality = municipality_service.municipality if municipality_service.subdomain_valid?
    if @current_municipality.blank?
      redirect_to "http://#{ADMIN_URL}/municipalities?municipality_suggestion=#{municipality_service.slug_name}"
    end
  end

  def scope_current_tenant
    MunicipalityService.municipality_id = @current_municipality.id
    yield
  ensure
    MunicipalityService.municipality_id = nil
  end

  included do
    before_action :determine_municipality
    around_action :scope_current_tenant
  end
end
