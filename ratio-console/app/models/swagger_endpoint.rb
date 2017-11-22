require 'net/http'
require 'uri'

class SwaggerEndpoint
  SWAGGER_URL = 'http://localhost:8080'
  
  def toggle_device_status(device_id,status_id)
    query_url = "#{SWAGGER_URL}/status/change/#{device_id}?state=#{status_id}"
    make_request(query_url)
  end
  
  def query_device_status(device_id)
    query_url = "#{SWAGGER_URL}/status/query/#{device_id}"
    make_request(query_url)
  end
    
  
  private
  def make_request(url, as_json: true)
    uri = URI.parse(url)
    
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    
    response = http.request(request)
    
    response_hash = make_json(response.body)
    
    { status_code: response.code, body: response_hash[:json], is_json: response_hash[:is_json] }
  end
  
  def make_json(json)
    result = JSON.parse(json)
    return { is_json: true, json: result }
  rescue JSON::ParserError => e
    return { is_json: false, json: json }
  end
end