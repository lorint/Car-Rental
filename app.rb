require './config/environment'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'

require 'erb'

set :views, './views'

# Found the crazy secret by running:
#   bundle exec rake secret
use Rack::Session::Cookie, expire_after: 2592000,
  secret: "a861497d116d411c6455b18395739f9857035132fb08c307b4fae7c2e486a2b4981ac6d273a5d49fe2d4a193cff8a0e3ba9a852c057db84242abd3800b2d9f97"

def current_user
  User.find_by(id: session[:user_id])
end

# We ALWAYS get params (a hash), and it is built from:
#  1. Any :var thing in the path  (Like '/users/:id' would give :id)
#  2. Any incoming form parameter (<input name="fred"> would give :fred)
#  3. Anything on the querystring (http://localhost:4567/abc?def=ghi would give :def)

get "/users" do
  @users = User.all.order(:name)
  erb :users_index
end

get "/users/:id/edit" do
  @user = User.find(params[:id])
  @roles = Role.all.order(:name)
  erb :users_edit
end

post "/users/:id" do
  user = User.find(params[:id])
  params[:user]["role_ids"] -= ["-1"]
  user.update(params[:user])
  redirect to("/users")
end

get "/roles" do
  @roles = Role.all.order(:name)
  erb :roles_index
end

get "/roles/:id/edit" do
  @role = Role.find(params[:id])
  @users = User.all.order(:name)
  erb :roles_edit
end

post "/roles/:id" do
  role = Role.find(params[:id])
  params[:role]["user_ids"] -= ["-1"]
  role.update(params[:role])
  redirect to("/roles")
end

after do
  ActiveRecord::Base.connection.close
end
