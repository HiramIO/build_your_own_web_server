
require 'socket'
host = 'localhost'
port = 2000

server = TCPServer.open(host, port)
puts "Server started on #{host}:#{port} ..."

loop do
  client = server.accept
  lines = []
  while (line = client.gets) && !line.chomp.empty?
    lines << line.chomp
  end
  puts lines

  filename = lines[0].gsub(/GET\ \//,'').gsub(/\ HTTP.*/,'')

  if File.exists?(filename)
    response_body = File.read(filename)
    success_header = []
    success_header << "HTTP/1.1 200 OK"
    success_header << "Content-Type: text/html"
    success_header << "Content-Length: #{response_body.length}"
    success_header << "Connection: close"
    header = success_header.join("\r\n")
  else
    response_body = "File not found\n"
    not_found_header = []
    not_found_header << "HTTP/1.1 404 Not Found"
    not_found_header << "Content-Type: text/plain"
    not_found_header << "Content-Length: #{response_body.length}"
    not_found_header << "Connection: close"
    header = not_found_header.join("\r\n")
  end
  response = [header, response_body].join("\r\n\r\n")
  client.puts(response)
  client.close
end