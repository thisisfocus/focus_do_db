Gem::Specification.new do |s|
  s.name = "focus_do_db"
  s.version = "0.1.0"
  s.summary = "Focus Digital Ocean DB Connections"
  s.authors = ["Neil Smith", "Tyler Samuelson"]
  s.files = ["lib/**/*"]

  s.add_dependency('droplet_kit')
  s.add_dependency('paint')
end
