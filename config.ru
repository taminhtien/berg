require "rack/rewrite"
require "rack/ssl"
require "rack/cors"

use Rack::Cors do
  if ENV["CANONICAL_DOMAIN"] && ENV["PRECOMPILED_ASSETS_HOST"]
    allow do
      origins ENV["CANONICAL_DOMAIN"]
      resource "/assets/*", :headers => :any, :methods => :get
    end
  end
end

use Rack::Rewrite do
  # if ENV["RACK_ENV"] == "production"
  #   r301 %r{.*}, "https://icelab.com.au$&", if: -> rack_env {
  #     rack_env["SERVER_NAME"] != "icelab.com.au"
  #   }
  # end

  # add additional rewrite rules here
  r301 "/admin", "/admin/posts"
  r301 "/services", "/work"
  r301 %r{/articles(.*)}, "/notes$1"
end

# Disable this until we setup SSL
use Rack::SSL if ENV["RACK_ENV"] == "production"
use Rack::Deflater

require_relative "component/boot"
run Berg::Application.freeze.app
