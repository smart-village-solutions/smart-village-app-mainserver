# frozen_string_literal: true

# Base class for POST and GET requests
#
# @author Marco Metz, Holger Frohloff
# @uri      [String] The Uri that is targeted with the request
# @login    [String] default=nil, A login for HTTP Basic Auth
# @password [String] default=nil, A password for HTTP Basic Auth
# @params   [Hash]   An optional hash of parameters for the request
#
require "addressable/uri"

class ApiRequestService
  def initialize(uri, login=nil, password=nil, params = {}, headers = {})
    @uri = uri
    @login = login
    @password = password
    @params = params
    @headers = headers
    @request = nil
  end

  def get_request(content_type_xml=false)
    return nil if @uri.blank?

    uri = Addressable::URI.parse(@uri.strip).normalize

    uri.query = [uri.query, URI.encode_www_form(@params)].join("&") if @params && @params.any?

    @request = Net::HTTP::Get.new(uri.request_uri)

    if content_type_xml
      @request.set_content_type("text/xml")
      @request["accept"] = "text/xml"
    end

    if @login.present? && @password.present?
      @request.basic_auth(@login, @password)
    end

    @headers.each do |key, value|
      @request.add_field key, value
    end

    http = Net::HTTP.new(uri.hostname, uri.port)

    if @uri.include?("https://")
      http = Net::HTTP.new(uri.hostname, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    http.request(request)

  rescue Timeout::Error
    raise ApiTimeoutError
  end

  def post_request
    url = Addressable::URI.parse(@uri.strip).normalize
    http = Net::HTTP.new(url.host, url.port || 80)

    if @uri.include?("https://")
      http = Net::HTTP.new(url.hostname, url.port || 443)
      http.use_ssl = true
      http.ssl_version = :SSLv23
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    @request = Net::HTTP::Post.new(
      url.path,
      "Content-Type" => headers.fetch(:content_type, "application/json")
    )
    @request.body = @params.to_json

    @headers.each do |key, value|
      @request.add_field key, value
    end

    http.request(request)
  end

  def delete_request
    url = Addressable::URI.parse(@uri.strip).normalize
    http = Net::HTTP.new(url.host, url.port || 80)

    if @uri.include?("https://")
      http = Net::HTTP.new(url.hostname, url.port || 443)
      http.use_ssl = true
      http.ssl_version = :SSLv23
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    @request = Net::HTTP::Delete.new(
      url.path,
      "Content-Type" => headers.fetch(:content_type, "application/json")
    )
    @request.body = @params.to_json

    @headers.each do |key, value|
      @request.add_field key, value
    end

    http.request(request)
  end

  def put_request
    url = Addressable::URI.parse(@uri.strip).normalize
    http = Net::HTTP.new(url.host, url.port || 80)

    if @uri.include?("https://")
      http = Net::HTTP.new(url.hostname, url.port || 443)
      http.use_ssl = true
      http.ssl_version = :SSLv23
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    @request = Net::HTTP::Put.new(
      url.path,
      "Content-Type" => headers.fetch(:content_type, "application/json")
    )
    @request.body = @params.to_json

    @headers.each do |key, value|
      @request.add_field key, value
    end

    http.request(request)
  end

  def post_file
    url = Addressable::URI.parse(@uri.strip).normalize
    http = Net::HTTP.new(url.host, url.port || 80)

    if @uri.include?("https://")
      http = Net::HTTP.new(url.hostname, url.port || 443)
      http.use_ssl = true
      http.ssl_version = :SSLv23
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    @request = Net::HTTP::Post.new(
      url.path,
      "Content-Type" => headers.fetch(:content_type, "application/json")
    )
    @request.set_form([['filename', @params]], 'multipart/form-data')

    @headers.each do |key, value|
      @request.add_field key, value
    end

    http.request(request)
  end

  def to_s
    {
      request: request,
      body: request.body.to_s,
      headers: headers,
      login: login,
      params: params,
      uri: uri
    }.to_s
  end

  private

  attr_reader :uri, :headers, :request, :login, :password, :params
end

# A custom error class.
#
# API requests might time out. Whenever a timeout error occurs, a custom ApiTimeoutError is raised.
# Currently this has no specific effect.
#
# @author Holger Frohloff
class ApiTimeoutError < StandardError

end
