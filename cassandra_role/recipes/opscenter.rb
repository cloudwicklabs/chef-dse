# Set up datastax repo in yum for rhel
yum_repository 'datastax' do
  description 'DataStax Repo for Apache Cassandra'
  baseurl node['cassandra_role']['dse_repo_url']
  gpgcheck false
  action :add
end

yum_package 'datastax-agent' do
  action :install
end

# template "#{node['cassandra_role']['datastax-agent-conf']}/address.yaml" do
#   source 'address.yaml.erb'
#   owner 'root'
#   group 'root'
# end

service 'datastax-agent' do
  action :start
end
