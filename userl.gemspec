Gem::Specification.new do |s|
  s.name        = 'userl'
  s.version     = '0.1.1'
  s.date        = '2012-10-01'
  s.summary     = "A CLI to get the most used languages of a GitHub user"
  s.description = "A CLI to get the most used languages of a GitHub user"
  s.authors     = ["Marco Sero"]
  s.email       = 'marco@marcosero.com'
  s.files       = ["lib/userl.rb"]
  s.homepage    = 'https://github.com/MarcoSero/userl'
  s.executables << 'userl'
  s.add_runtime_dependency "terminal-table", [">= 1.4.5"]
  s.add_runtime_dependency "json", [">= 1.4.5"]
end