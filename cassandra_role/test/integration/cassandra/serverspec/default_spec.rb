# Encoding: utf-8

require_relative 'spec_helper'

describe ('Validate Cassandra configurations') do
  describe service('dse') do
    it { should be_enabled }
    it { should be_running }
  end

describe ('validate sysctl configurations') do
  describe file('/etc/sysctl.d/99-chef-attributes.conf') do
    it { should be_file }
    its(:content) { should match /vm.max_map_count=131072/ }
    its(:content) { should match /vm.swappiness=0/ }
  end
end

describe ('validate if swap is turned off') do
  describe command('swapon -s | grep -v Filename | grep partition') do
    its(:exit_status) { should eq 1 }
  end
end

describe ('validate logrotate configuration') do
  describe file('/etc/logrotate.d/cassandra-logrotate') do
    it { should be_file }
    its(:content) { should match /maxage 7/ }
    its(:content) { should match /daily/ }
  end
end

describe ('Validate java configurations') do
  describe file('/opt/java') do
    it { should be_symlink }
  end

  describe command('alternatives --display java') do
    its(:stdout) { should match /java - status is auto/ }
    its(:stdout) { should match /version is \/opt\/java\/bin\/java/ }
  end
end
