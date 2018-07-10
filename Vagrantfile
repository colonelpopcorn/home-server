Vagrant.configure("2") do |config|

  config.ssh.forward_agent = true
  N = 2
  (0..N).each do |machine_id|
    if machine_id == 0
      machine_name = "swarm-manager"
    else
      machine_name = "swarm-worker-#{machine_id}"
    end
    config.vm.define machine_name do |machine|
      machine.vm.box = "ubuntu/xenial64"
      machine.vm.hostname = machine_name
      machine.vm.network "private_network", ip: "10.0.0.#{10+machine_id}"
      ssh_key = File.readlines("#{Dir.home}/.ssh/vagrant_machine_key").first.strip
      machine.vm.provision "shell" do |s|
        s.inline = <<-SHELL
          sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install python2.7 -y && sudo ln -s /usr/bin/python2.7 /usr/bin/python
          echo #{ssh_key} >> /home/vagrant/.ssh/id_rsa
          chown vagrant /home/vagrant/.ssh/id_rsa
          chmod 400 /home/vagrant/.ssh/id_rsa
        SHELL
      end

      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.become = true
          ansible.groups = {
            "manager" => ["swarm-manager"],
            "workers" => ["swarm-worker-1", "swarm-worker-2"],
            "manager:vars" => {
              "swarm_role" => "manager"
            },
            "workers:vars" => {
              "swarm_role" => "worker"
            }
          }
          ansible.raw_arguments = [
            "--private-key=#{Dir.home}/.ssh/vagrant_machine_key"
          ]
          ansible.galaxy_role_file = "scripts/requirements.yml"
          ansible.playbook = "scripts/bootstrap.yml"
        end
      end
    end
  end
end
