$:.unshift(File.dirname(__FILE__) + '/lib')
require 'ubuntu_ami/version'
Gem::Specification.new do |s|
  s.name = 'ubuntu_ami'
  s.version = Ubuntu::Ami::VERSION
  s.summary = "Retrieves AMI information from Canonical's Ubuntu release list."
  s.description = s.summary + "Also provides a knife plugin to retrieve the list."
  s.author = "Joshua Timberman"
  s.email = "joshua@chef.io"
  s.homepage = "https://github.com/jtimberman/ubuntu_ami"
  s.require_path = 'lib'
  s.files = %w(LICENSE) + Dir.glob("lib/**/*")
  s.license = "Apache-2.0"
end
