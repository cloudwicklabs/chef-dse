

#
# Cookbook Name:: cassandra_ddn_role
# Recipe:: default
#
# Copyright 2015, Rajendra K
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
#

include_recipe 'blackbird_base_tgtcfg::default'
include_recipe 'cassandra_tgtcfg::default'
include_recipe 'cassandra_ddn_role::_customconfig'

# set up log 4j temlate
begin
  r = resources(:template => "#{node['cassandra']['dse']['conf_dir']}/cassandra/log4j-server.properties")
  r.cookbook 'cassandra_ddn_role'
  r.source 'log4j-server.properties.erb'
  r.variables(
    :dir => node['cassandra']['log_dir']
  )
  r.owner node['cassandra']['user']
  r.group node['cassandra']['group']
  r.notifies :restart, "service[#{node['cassandra']['dse']['service_name']}]"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'Could not find template to override!'
end

directory '/logs/cassandra' do
  owner 'cassandra'
  group 'cassandra'
  mode '0755'
  action :create
  recursive true
end

begin
  k = resources(:template => "#{node['cassandra']['dse']['conf_dir']}/cassandra/cassandra-env.sh")
  k.cookbook 'cassandra_ddn_role'
  k.source 'cassandra-env.sh.erb'
  k.owner node['cassandra']['user']
  k.group node['cassandra']['group']
  k.notifies :restart, "service[#{node['cassandra']['dse']['service_name']}]"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'Could not find template to override!'
end

begin
  a = resources(:template => "#{node['cassandra']['dse']['conf_dir']}/cassandra/cassandra-rackdc.properties")
  a.cookbook 'cassandra_ddn_role'
  a.source 'cassandra-rackdc.properties.erb'
  a.owner node['cassandra']['user']
  a.group node['cassandra']['group']
  a.notifies :restart, "service[#{node['cassandra']['dse']['service_name']}]"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn 'Could not find template to override!'
end

include_recipe 'cassandra_ddn_role::_cassandra_ssl'
execute 'java' do
  command 'update-alternatives --set java /apps/install/java/bin/java'
end

include_recipe 'cassandra_ddn_role::opscenter'

template "#{node['cassandra_ddn_role']['datastax-agent-conf']}/address.yaml" do
  source 'address.yaml.erb'
  owner 'root'
  group 'root'
end

include_recipe 'cassandra_ddn_role::_cron'

file '/logs/cassandra/nodetool_repair.log' do
  mode '0755'
  owner 'cassandra'
  group 'cassandra'
  action :create
end

directory '/root/.cassandra' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

template '/root/.cassandra/cqlshrc' do
  source '_cqlshrc.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

template '/root/user.sh' do
  source 'user.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# bash 'user' do
#   user 'root'
#   code <<-EOH
#   /root/user.sh
#   EOH
#   not_if do
#     File.exist?("/root/user.sh")
#   end
# end
