require 'rubygems'
require 'active_record'
require 'sinatra'
require "#{File.dirname(__FILE__)}/models/user"

env_index = ARGV.index("-e")
env_arg = ARGV[env_index + 1] if env_index
env = env_arg || ENV["SINATRA_ENV"] || "development"
databases = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(databases[env])

get '/users/all' do
  users = User.all

  if !users.empty?
    users.to_json
  else
    error 404, {:error => "No users on file."}.to_json
  end
end

get '/users/:guid' do
  user = User.find_by_guid(params[:guid])
  if user
    user.to_json
  else
    error 404, {:error => "User not found."}.to_json
  end
end

post '/users' do
  user = User.create(JSON.parse(request.body.read))
  begin
    if user.valid?
      user.to_json
    else
      error 400, user.errors.to_json
    end
  rescue => e
    error 400, e.message.to_json
  end
end

put '/users/:guid' do
  user = User.find_by_guid(params[:guid])
  if user
    begin
      if user.update_attributes(JSON.parse(request.body.read))
        user.to_json
      else  
        error 400, user.errors.to_json
      end
    rescue => e
      error 400, e.message.to_json
    end
  else
    error 400, {:error => "User not found."}.to_json
  end
end

