require 'test/unit'
require 'ubuntu_ami'

module TestHelper
  def expected_amis(release)
    case release
    when "lucid"
      %w[ami-f092eca2 ami-f292eca0 ami-c692ec94 ami-2492ec76 ami-3d1f2b49 ami-311f2b45 ami-631f2b17 ami-a11e2ad5 ami-3202f25b ami-3e02f257 ami-fa01f193 ami-7000f019 ami-f5bfefb0 ami-ebbfefae ami-e1bfefa4 ami-19bfef5c]
    end
  end
end

alias :__open__ :open
def open(url)
  path = url.match(/.*\.com\/(.+)/)[1]
  base_dir = File.expand_path(File.dirname(__FILE__))
  __open__("#{base_dir}/data/#{path}")
end

class TestUbuntu < Test::Unit::TestCase
  include TestHelper

  def test_find
    ami = Ubuntu.release("lucid").amis.find do |ami|
      ami.arch == "amd64" and
        ami.root_store == "instance-store" and
        ami.region == "us-east-1"
    end

    assert_equal "ami-fa01f193", ami.name
  end

  def test_ami_attributes
    ami = Ubuntu.release("lucid").amis.first
    assert_equal "ami-f092eca2", ami.name
    assert_equal "amd64", ami.arch
    assert_equal "ebs", ami.root_store
    assert_equal "ap-southeast-1", ami.region
    assert_equal "paravirtual", ami.virtualization_type
  end

  def test_list_amis
    assert Ubuntu.release("lucid").amis.size > 0
    assert_equal expected_amis("lucid"), Ubuntu.release("lucid").amis.map{|a| a.name }
  end
end
