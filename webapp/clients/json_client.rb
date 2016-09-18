module JsonClient
  extend self

  def execute(request)
    MultiJson.load(RestClient::Request.execute({
      method: request.method, url: request.url,
      payload: request.body, headers: request.headers,
    }))
  end
end
