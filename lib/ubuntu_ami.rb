#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Description:: Retrieves AMI information from Canonical's AMI release list.
#
# Copyright:: 2011, Joshua Timberman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'pp'
require 'open-uri'

class UbuntuAmi
  def initialize(release)
    @uri = "http://uec-images.ubuntu.com/query/#{release}/server/released.current.txt"
  end

  def arch_size(arch)
    arch =~ /amd64/ ? "large" : "small"
  end

  def disk_store(store)
    "_ebs" if store =~ /ebs/
  end

  def region_fix(region)
    region.gsub(/-1/,'').gsub(/-/,'_')
  end

  def virtualization_type(line)
    virtualization = line.split[8..9].last
    "_#{virtualization}" if virtualization != "paravirtual"
  end

  def run
    amis = {}
    open(@uri).each do |a|
      key = a.split[4..6]
      ami = a.split[7]
      amis["#{region_fix(key[2])}_#{arch_size(key[1])}#{disk_store(key[0])}#{virtualization_type(a)}"] = ami
    end
    amis
  end
end


class Ubuntu
  attr_reader :release_name

  def self.release(release_name)
    new(release_name)
  end

  def initialize(release_name)
    @release_name = release_name
  end

  def amis
    require 'open-uri'
    lucid_content = open("http://uec-images.ubuntu.com/query/#{release_name}/server/released.current.txt")
    lucid_content.map {|line| line.split[7] }.sort
  end
end
