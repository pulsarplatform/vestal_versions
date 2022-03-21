Gem::Specification.new do |s|
  s.name    = 'vestal_versions'
  s.version = '1.2.4'

  s.authors     = ['Steve Richert', "James O'Kelly"]
  s.email       = ['steve.richert@gmail.com', 'dreamr.okelly@gmail.com']
  s.description = "Keep a DRY history of your ActiveRecord models' changes"
  s.summary     = s.description
  s.homepage    = 'http://github.com/laserlemon/vestal_versions'

  s.add_dependency 'activerecord', '~> 3.0'
  s.add_dependency 'activesupport', '~> 3.0'

  s.files         = Dir['{*.md,Gemfile,*.gemspec,Rakefile,lib/**/*,gemfiles/**/*}']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']
end
