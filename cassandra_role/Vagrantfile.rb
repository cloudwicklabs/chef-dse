file_to_disk = './tmp/large_disk.vdi'
Vagrant.configure("2") do |c|
  c.berkshelf.enabled = false if Vagrant.has_plugin?("vagrant-berkshelf")
  c.vm.box = "centos66"
  c.vm.box_url = ""
  c.vm.hostname = "cassandra"
  c.vm.network(:private_network, {:ip=>""})
  c.vm.synced_folder ".", "/vagrant", disabled: true
  c.vm.provider :virtualbox do |p|
    p.customize ["modifyvm", :id, "--memory", "2048"]
    p.customize ["modifyvm", :id, "--cpus", "2"]
    unless File.exist?(file_to_disk)
        p.customize ['createhd', '--filename', file_to_disk, '--size', 100 * 1024]
    end
    p.customize ['storageattach', :id,
      '--storagectl', 'IDE Controller',
      '--port', '1',
      '--device', '1',
      '--type', 'hdd',
      '--medium', file_to_disk]
    end
end
