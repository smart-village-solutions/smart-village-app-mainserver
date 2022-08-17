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
    return if subdomains.length == 0

    # wenn Anzahl der Subdomains 1 dann wird das Admin UI ausgewählt, sofern die Subdomain nicht "server" ist
    # http://server.smart-village.local
    # http://server.smart-village.app
    return if subdomains.length == 1 && subdomains.last == "server"

    # wenn Anzahl der Subdomains größer 2 ist, dann wird ein Fehler geworfen
    # http://bad-belzig.foo.server.smart-village.de
    raise "municipality error: subdomain size to high" if subdomains.count > 2

    # Wenn Anzahl der Subdomains stimmt, aber die letzte Subdomain nicht mit "server" endet, dann wird ein Fehler geworfen
    raise "municipality error: subdomain order failed" unless subdomains.last == "server"

    # In allen anderen Fällen ist an der ersten Stelle von :subdomains der Name der Kommune
    # TODO: Prüfen, ob die Kommune existiert
    @current_municipality = subdomains # Municipality.find_by(slug: subdomains.first)
  end

  included do
    before_action :determine_municipality
  end
end
