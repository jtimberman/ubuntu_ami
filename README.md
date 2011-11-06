# Usage
        ami = Ubuntu.release("lucid").amis.find do |ami|
          ami.arch == "amd64" and
          ami.root_store == "instance-store" and
          ami.region == "us-east-1"
        end
