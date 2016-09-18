require 'bundler/setup'
require 'multi_json'
require 'oj'
require 'sinatra/base'
require 'haml'
require 'rest-client'
require 'base64'

Dir.glob('./webapp/*/*.rb').each do |file|
  require file
end

Config = Configuration.new(File.join(__dir__, 'settings.yml'), ENV['RACK_ENV'])
