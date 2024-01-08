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

    redirect_to("https://#{ADMIN_URL}/municipalities") and return if municipality_service.admin_domain?

    @current_municipality = municipality_service.municipality if municipality_service.subdomain_valid?
    if @current_municipality.blank?
      redirect_to "https://#{ADMIN_URL}/municipalities?municipality_suggestion=#{municipality_service.slug_name}"
    end
  end

  def scope_current_tenant
    MunicipalityService.municipality_id = @current_municipality.id
    MunicipalityService.set_data_resource_redis_adapter
    s3_service.set_bucket(@current_municipality) if @current_municipality.minio_config_valid?
    yield
  ensure
    MunicipalityService.municipality_id = nil
  end

  def s3_service
    service = ActiveStorage::Blob.service
    return unless service.class.to_s == "ActiveStorage::Service::MultiBucketService"

    service
  end

  included do
    before_action :determine_municipality
    around_action :scope_current_tenant
  end
end
