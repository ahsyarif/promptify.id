require "net/http"

module Midtrans
  class Error < StandardError; end

  module_function

  def server_key
    ENV["MIDTRANS_SERVER_KEY"].presence ||
      Rails.application.credentials.dig(:midtrans, :server_key) ||
      raise(Error, "Midtrans server key missing")
  end

  # Sandbox keys start with "SB-"; that alone decides the environment.
  def base_url = server_key.start_with?("SB-") ? "https://api.sandbox.midtrans.com" : "https://api.midtrans.com"

  def charge_qris(order_id:, amount:, email:)
    request Net::HTTP::Post, "/v2/charge", {
      payment_type: "qris",
      transaction_details: { order_id: order_id, gross_amount: amount },
      item_details: [ { id: "lifetime-membership", price: amount, quantity: 1, name: "Promptify lifetime membership" } ],
      customer_details: { email: email }
    }
  end

  def status(order_id) = request(Net::HTTP::Get, "/v2/#{order_id}/status")

  def valid_signature?(params)
    expected = Digest::SHA512.hexdigest("#{params[:order_id]}#{params[:status_code]}#{params[:gross_amount]}#{server_key}")
    ActiveSupport::SecurityUtils.secure_compare(expected, params[:signature_key].to_s)
  end

  def request(verb, path, body = nil)
    uri = URI("#{base_url}#{path}")
    req = verb.new(uri, "Accept" => "application/json", "Content-Type" => "application/json")
    req.basic_auth(server_key, "")
    req.body = body.to_json if body
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) { |http| http.request(req) }
    json = JSON.parse(res.body)
    unless res.is_a?(Net::HTTPSuccess) && json["status_code"].to_s.start_with?("2")
      raise Error, json["status_message"] || "HTTP #{res.code}"
    end
    json
  rescue JSON::ParserError, SocketError, SystemCallError, Net::OpenTimeout, Net::ReadTimeout => e
    raise Error, e.message
  end
end
