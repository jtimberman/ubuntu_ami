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

    # Substitutes dashes for underscores in region portion of type for
    # nice display. Replaces "1" as implied for most regions.
    #
    # === Parameters
    # region<String>:: comes from Ubuntu::Ami#region
    #
    # === Returns
    # String:: e.g., us_east_small or us_east_small_ebs
    def region_fix(region)
      region.gsub(/-1/,'').gsub(/-/,'_')
    end

    # Identifies the virtualization type as HVM if image is HVM.
    #
    # === Parameters
    # type<String>:: comes from Ubuntu::Ami#virtualization_type
    #
    # === Returns
    # String:: "_hvm" if the #virtualization_type is HVM, otherwise empty.
    def virt_type(type)
      type =~ /hvm/ ? "_hvm" : ''
    end

    # Indicates whether a particular image has EBS root volume.
    #
    # === Parameters
    # store<String>:: comes from Ubuntu::Ami#root_store
    #
    # === Returns
    # String:: "_ebs" if the #root_store is EBS, _ebs_ssd if ebs-ssd,
    # _ebs_io1 if provisioned IOPS, etc. Otherwise empty.
    def disk_store(store)
      if store =~ /ebs/
        "_#{store.tr('-', '_')}"
      else
        ''
      end
    end

    # Indicates whether the architecture type is a large or small AMI.
    #
    # === Parameters
    # arch<String>:: Values can be amd64, x86_64, large, or begin with
    # "64". Intended to be from Ubuntu::Ami#arch, but this method
    # move to Ubuntu directly.
    #
    # === Returns
    # String:: For 64 bit architectures (Ubuntu::Ami#arch #=> amd64),
    # this will return "large". Otherwise, it returns "small".
    def size_of(arch)
      String(arch) =~ /(amd64|x86_64|large|^64)/ ? "large" : "small"
    end

    # Makes a nice string for the type of AMI to display, including
    # the region, architecture size and whether the AMI has EBS root
    # store.
    #
    # === Parameters
    # region<String>:: from Ubuntu::Ami#region
    # arch<String>:: from Ubuntu::Ami#arch
    # root_store<String>:: from Ubuntu::Ami#root_store
    #
    # === Returns
    # String:: The region, arch and root_store (if EBS) concatenated
    # with underscore (_).
    def build_type(region, arch, root_store, type)
      "#{region_fix(region)}_#{size_of(arch)}#{disk_store(root_store)}#{virt_type(type)}"
    end

    # Iterates over the AMIs available for the specified distro.
    #
    # === Parameters
    # distro<String>:: Release name of the distro to display.
    #
    # === Returns
    # Hash:: Keys are the AMI type, values are the AMI ID.
    def list_amis(distro)
      amis = Hash.new
      Ubuntu.release(distro).amis.each do |ami|
        amis[build_type(ami.region, ami.arch, ami.root_store, ami.virtualization_type)] = ami.name
      end
      amis
    end

    # Runs the plugin. If TYPE (name_args[1]) is passed, then select a
    # specified type, based on #build_type, above.
    def run
      distro = name_args[0]
      type = name_args[1]
      ami_list = list_amis(distro)[type] || list_amis(distro)
      output(format_for_display(ami_list))
    end

  end
end
