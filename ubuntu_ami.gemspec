Gem::Specification.new do |s|
  s.name = 'ubuntu_ami'
  s.version = '0.2'
  s.platform = Gem::Platform::RUBY
  s.summary = "Retrieves AMI information from Canonical's Ubuntu release list."
  s.description = s.summary
  s.author = "Joshua Timberman"
  s.email = "joshua@opscode.com"
  s.homepage = "http://github.com/jtimberman/ubuntu_ami"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
  s.executables = ["ubuntu_ami"]
end
