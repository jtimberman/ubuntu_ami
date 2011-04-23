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

    banner "knife ec2 amis ubuntu DISTRO [TYPE]"

    def run
      distro = name_args[0]
      type = name_args[1]
      ami_list = UbuntuAmi.new(distro).run[type] || UbuntuAmi.new(distro).run
      output(format_for_display(ami_list))
    end

  end
end
