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
    subdomains = request.subdomains

    # wenn Anzahl der Subdomains 0, dann wird das Admin UI ausgewählt
    # http://localhost:4000
    redirect_to("http://#{ADMIN_URL}/municipalities") and return if subdomains.length == 0

    # wenn Anzahl der Subdomains 1 dann wird das Admin UI ausgewählt, sofern die Subdomain "server" ist
    # http://server.smart-village.local
    # http://server.smart-village.app
    if subdomains.length == 1 && subdomains.last == "server"
      redirect_to("http://#{ADMIN_URL}/municipalities") and return
    end

    # wenn Anzahl der Subdomains 1 und die Subdomain nicht "server" ist
    # dann sollte diese Domain nicht auf diese Applikation zeigen
    if subdomains.length == 1 && subdomains.last != "server"
      raise "municipality error: subdomain not assigned"
    end

    # wenn Anzahl der Subdomains größer 2 ist, dann wird ein Fehler geworfen
    # http://bad-belzig.foo.server.smart-village.de
    raise "municipality error: subdomain size to high" if subdomains.count > 2

    # Wenn Anzahl der Subdomains stimmt, aber die letzte Subdomain nicht mit "server" endet, dann wird ein Fehler geworfen
    raise "municipality error: subdomain order failed" unless subdomains.last == "server"

    # In allen anderen Fällen ist an der ersten Stelle von :subdomains der Name der Kommune
    slug_name = subdomains.first.to_s.downcase
    @current_municipality = Municipality.find_by(slug: slug_name)

    if @current_municipality.blank?
      redirect_to "http://#{ADMIN_URL}/municipalities?municipality_suggestion=#{slug_name}"
    end
  end

  included do
    before_action :determine_municipality
  end
end
