#
# Author:: Joshua Timberman (<joshua@housepub.org>), Michael Hale (<mike@hales.ws>)
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

require 'open-uri'

class Ubuntu
  attr_reader :release_name

  def self.release(release_name)
    instance_for_release(release_name)
  end

  def self.instance_for_release(release_name)
    @releases ||= {}
    @releases[release_name] ||= new(release_name)
  end

  def initialize(release_name)
    @release_name = release_name
  end

  def amis
    content.map do |line|
      Ami.new(
              line.split[7],
              line.split[4],
              line.split[5],
              line.split[6],
              line.split[8..9].last)
    end
  end

  def url
    "http://uec-images.ubuntu.com/query/#{release_name}/server/released.current.txt"
  end

  def content
    begin
      @content ||= open(url).read.split("\n")
    rescue
      raise "Could not find AMI list for distro release '#{release_name}', did you specify it correctly? (e.g., 'lucid')"
    end
  end

  class Ami
    attr_reader :name, :root_store, :arch, :region, :virtualization_type

    def initialize(name, root_store, arch, region, virtualization_type)
      @name = name
      @root_store = root_store
      @arch = arch
      @region = region
      @virtualization_type = virtualization_type
    end
  end
end
