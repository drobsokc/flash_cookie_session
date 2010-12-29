module FlashCookieSession
  class Middleware
    def initialize(app, session_key = '_session_id')
      @app = app
      @session_key = session_key
    end

    def call(env)
      if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
        req = Rack::Request.new(env)
        env['HTTP_COOKIE'] = [ @session_key, req.params[@session_key] ].join('=').freeze if req.params[@session_key]
        env['HTTP_ACCEPT'] = "#{req.params['_http_accept']}".freeze if req.params['_http_accept']
	env['HTTP_ACCEPT'] = '*/*'   
   end

      @app.call(env)
    end
  end
end
