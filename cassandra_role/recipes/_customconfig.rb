#
# Cookbook Name:: cassandra_ddn_role
# Recipe:: customconfig
#
# All rights reserved - Do Not Redistribute
#
java_version = node['java']['jdk_version']
# Download the jars for Unlimited Strength Jurisdiction Policy Files
filename = File.basename(node['java'][java_version]['policy_files_src'])

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source node['java'][java_version]['policy_files_src']
  action :create_if_missing
end

policy_folder_name = node['java'][java_version]['policy_unzip_folder_name']
# Place the poilcy files under java/lib/security
execute 'Update-policy-jars for Unlimited Strength Jurisdiction' do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
    # Run installer
    unzip "#{Chef::Config[:file_cache_path]}/#{filename}"
    cd #{policy_folder_name}
    cp US_export_policy.jar local_policy.jar #{node['java']['java_home']}/jre*/lib/security/
  EOH
end

# cleanup the temp files from file_cache_path
execute "cleanup #{filename} from cache" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
    rm -f "#{Chef::Config[:file_cache_path]}/#{filename}"
  EOH
  only_if { File.exist?("#{Chef::Config[:file_cache_path]}/#{filename}") }
end

# cleanup the temp files from file_cache_path
execute 'cleanup UnlimitedJCEPolicy from cache' do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
    rm -rf "#{Chef::Config[:file_cache_path]}/UnlimitedJCEPolicy"
  EOH
  only_if { File.directory?("#{Chef::Config[:file_cache_path]}/UnlimitedJCEPolicy") }
end
