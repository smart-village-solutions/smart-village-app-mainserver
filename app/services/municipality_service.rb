# frozen_string_literal: true

# Achtung!!!
# Wenn man in der Console Daten für eine bestimmte Kommune sehen will
# dann muss vorab der "Tenant" gesetzt werden:
#
# MunicipalityService.municipality_id=1
#
# Für die Laufzeit dieses Threads ist dann die Kommune mit der ID 1 gesetzt.
# In den Models gibt es jeweils ein default_scope, der die Kommune entsprechend
# setzt. (include MunicipalityScope)
class MunicipalityService
  attr_accessor :subdomains, :slug_name

  # Methoden um auch in Models auf die aktuelle Kommune zu prüfen.
  # In einer around_action wird (bspw. im ApplicationController)
  # die ID für die Dauer des Threads gespeichert in einer Klassenvariable
  def self.municipality_id=(id)
    Thread.current[:municipality_id] = id
    rollbar_initializer(id) if id && Municipality.exists?(id)
    meilisearch_initializer(id) if id && Municipality.exists?(id)
    id
  end

  def self.municipality_id
    Thread.current[:municipality_id]
  end

  def self.settings
    return {} if Thread.current[:municipality_id].blank?

    Municipality.find_by(id: Thread.current[:municipality_id]).try(:settings) || {}
  end

  def self.slug
    Municipality.find_by(id: Thread.current[:municipality_id]).slug.presence
  end

  def initialize(subdomains:)
    @subdomains = subdomains
    @slug_name = @subdomains.first.to_s.downcase
  end

  def admin_domain?
    # wenn Anzahl der Subdomains 0, dann wird das Admin UI ausgewählt
    # http://localhost:4000
    return true if @subdomains.length == 0

    # wenn Anzahl der Subdomains 1 dann wird das Admin UI ausgewählt, sofern die Subdomain "server" ist
    # http://staging-server.smart-village.local
    # http://staging-server.smart-village.app
    return true if @subdomains.length == 1 && @subdomains.last == SUBDOMAIN_NAMESPACE
  end

  def subdomain_valid?
    # wenn Anzahl der Subdomains 1 und die Subdomain nicht "server" ist
    # dann sollte diese Domain nicht auf diese Applikation zeigen
    raise "municipality error: subdomain not assigned" if @subdomains.length == 1 && @subdomains.last != SUBDOMAIN_NAMESPACE

    # wenn Anzahl der Subdomains größer 2 ist, dann wird ein Fehler geworfen
    # http://bad-belzig.foo.staging-server.smart-village.de
    raise "municipality error: subdomain size to high" if @subdomains.count > 2

    # Wenn Anzahl der Subdomains stimmt, aber die letzte Subdomain nicht mit "server" endet, dann wird ein Fehler geworfen
    raise "municipality error: subdomain order failed" unless @subdomains.last == SUBDOMAIN_NAMESPACE

    true
  end

  def municipality
    Municipality.find_by(slug: slug_name)
  end

  def self.rollbar_initializer(id)
    current_settings = settings
    Rollbar.configuration.access_token = current_settings[:rollbar_access_token]
    Rollbar.configuration.payload_options = {
      municipality_id: id,
      minio_bucket: current_settings[:minio_bucket]
    }
  end

  def self.meilisearch_initializer(_id)
    current_settings = settings
    MeiliSearch::Rails.configuration = {
      meilisearch_url: current_settings.fetch(:meilisearch_url, nil).presence || Settings.meilisearch[:url],
      meilisearch_api_key: current_settings.fetch(:meilisearch_api_key, nil).presence || Settings.meilisearch[:api_key],
      per_environment: true,
      timeout: 30
    }
  end
end
