#
# Author:: Joshua Timberman (<joshua@housepub.org>)
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

require 'chef/knife'

module KnifePlugins
  class Ec2AmisUbuntu < Chef::Knife

    deps do
      begin
        require 'ubuntu_ami'
      rescue LoadError
        Chef::Log.error("Could not load Ubuntu AMI library.")
      end
    end

    banner "knife ec2 amis ubuntu DISTRO [TYPE] (options)"

    def region_fix(region)
      region.gsub(/-1/,'').gsub(/-/,'_')
    end

    def disk_store(store)
      store =~ /ebs/ ? "_ebs" : ''
    end

    def size_of(arch)
      String(arch) =~ /(amd64|x86_64|large|^64)/ ? "large" : "small"
    end

    def build_type(region, arch, root_store)
      "#{region_fix(region)}_#{size_of(arch)}#{disk_store(root_store)}"
    end

    def list_amis(distro)
      amis = Hash.new
      Ubuntu.release(distro).amis.each do |ami|
        amis[build_type(ami.region, ami.arch, ami.root_store)] = ami.name
      end
      amis
    end

    def run
      distro = name_args[0]
      type = name_args[1]
      ami_list = list_amis(distro)[type] || list_amis(distro)
      output(format_for_display(ami_list))
    end

  end
end
