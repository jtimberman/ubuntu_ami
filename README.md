This gem provides a library for retrieving Canonical's Ubuntu AMI
release list for Amazon EC2.

It also includes a knife plugin to easily retrieve AMIs for launching
instances with Chef.

# Usage

Find an AMI based on criteria:

    ami = Ubuntu.release("lucid").amis.find do |ami|
      ami.arch == "amd64" and
      ami.root_store == "instance-store" and
      ami.region == "us-east-1"
    end

Return certain information about the AMIs:

    Ubuntu.release("lucid").amis.each do |ami|
      puts "#{ami.region} #{ami.name} (#{ami.arch}, #{ami.root_store})"
    end

Use the knife plugin with Knife, from Chef. Pass just a distro name
for the list of available AMIs by type:

    knife ec2 amis ubuntu lucid

The first column will be the available types, and the second is the
associated AMI. Specify the type to return just the AMI.

    knife ec2 amis ubuntu lucid us_east_small

The type is made up of the region, the architecture size (small for 32
bit, large for 64 bit). If the AMI is an EBS root store, that will be indicated.

# License and Authors

Author:: Joshua Timberman (<joshua@housepub.org>)
Author:: Michael Hale (<mike@hales.ws>)

Copyright:: 2011, Joshua Timberman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
