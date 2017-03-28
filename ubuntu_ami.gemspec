$:.unshift(File.dirname(__FILE__) + '/lib')
require 'ubuntu_ami/version'
Gem::Specification.new do |s|
  s.name = 'ubuntu_ami'
  s.version = Ubuntu::Ami::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.summary = "Retrieves AMI information from Canonical's Ubuntu release list."
  s.description = s.summary + "Also provides a knife plugin to retrieve the list."
  s.author = "Joshua Timberman"
  s.email = "joshua@opscode.com"
  s.homepage = "http://github.com/jtimberman/ubuntu_ami"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
  s.executables = ["ubuntu_ami"]
end
