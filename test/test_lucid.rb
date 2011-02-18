require 'test/unit'
require 'ubuntu_ami'

module TestHelper
  def expected_amis(release)
    case release
    when "lucid"
      %w[ami-19bfef5c ami-2492ec76 ami-311f2b45 ami-3202f25b ami-3d1f2b49 ami-3e02f257 ami-631f2b17 ami-7000f019 ami-a11e2ad5 ami-c692ec94 ami-e1bfefa4 ami-ebbfefae ami-f092eca2 ami-f292eca0 ami-f5bfefb0 ami-fa01f193]
    end
  end
end

alias :__open__ :open
def open(url)
  path = url.match(/.*\.com\/(.+)/)[1]
  base_dir = File.expand_path(File.dirname(__FILE__))
  __open__("#{base_dir}/data/#{path}")
end

class TestLucid < Test::Unit::TestCase
  include TestHelper

  def test_list_amis
    assert Ubuntu.release("lucid").amis.size > 0
    assert_equal expected_amis("lucid"), Ubuntu.release("lucid").amis
  end
end
