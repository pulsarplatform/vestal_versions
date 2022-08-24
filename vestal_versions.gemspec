Gem::Specification.new do |s|
  s.name    = 'vestal_versions'
  s.version = '1.2.5'

  s.authors     = ['Steve Richert', "James O'Kelly"]
  s.email       = ['steve.richert@gmail.com', 'dreamr.okelly@gmail.com']
  s.description = "Keep a DRY history of your ActiveRecord models' changes"
  s.summary     = s.description
  s.homepage    = 'http://github.com/laserlemon/vestal_versions'

  s.add_dependency 'activerecord', '>= 6.1', '< 7.1'
  s.add_dependency 'activesupport', '>= 6.1', '< 7.1'

  s.files         = Dir['{*.md,Gemfile,*.gemspec,Rakefile,lib/**/*,gemfiles/**/*}']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']
end
