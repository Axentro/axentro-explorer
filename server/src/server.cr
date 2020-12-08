require "kemal"

get "/" do |context|
  context.response.content_type = "text/html"
  File.read(File.join("public", "index.html"))
end

# This is to pass all not found routes to the Mint app to handle
error 404 do |context|
  context.response.content_type = "text/html"
  context.response.status_code = 200
  File.read(File.join("public", "index.html"))
end
Kemal.run