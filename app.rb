require 'sinatra'

set :bind, '140.112.27.43'

get '/hi' do
  "Hello World!"
end

