# This file is used by Rack-based servers to start the application.
require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-facebook'
require 'open-uri'


require ::File.expand_path('../config/environment',  __FILE__)
run WebCal::Application
