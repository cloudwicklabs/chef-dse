
# Create the directories where ssl keys are stored
directory node['cassandra_role']['ssl_dir'] do
  owner node['cassandra']['user']
  group node['cassandra']['group']
  mode '0755'
  recursive true
end

# get the password for keystore and truststore

secret_key = Chef::EncryptedDataBagItem.load_secret
cassandra_ddn_databag = Chef::EncryptedDataBagItem.load('cassandra_ddn', node['cassandra_role']['cassandra_pass'], secret_key)

pass = cassandra_ddn_databag['cassandra']['keytool_storepass'] if cassandra_ddn_databag
node.override['cassandra_cw']['keystore_password'] = pass
node.override['cassandra_cw']['truststore_password'] = pass

# get the generated certificate from data_bag_item
cert_keys = encrypted_data_bag_item('cassandra_ddn', node['cassandra_role']['cassandra_ssl_databag'])
dcdload_cer = encrypted_data_bag_item('cassandra_ddn', node['cassandra_role']['dcdload'])

# loop through each certificate
cert_keys['ssl_cert'].each do |cert_file, content|
  cert_file_path = "#{node['cassandra_role']['ssl_dir']}/#{cert_file}.pem"
  file cert_file_path do
    mode '0400'
    content content
  end

  cert_key_name = nil
  # get relevant certificate key
  cert_keys['ssl_key'].each do |key_file, key|
    first = cert_file.match('_').pre_match
    if key_file == "#{first}_key"
      cert_key_path = "#{node['cassandra_role']['ssl_dir']}/#{key_file}.pem"
      cert_key_name = "#{key_file}.pem"
      file cert_key_path do
        mode '0400'
        content key
      end
    end
    next if key_file != "#{first}_key"
  end
  dcdload_cer['dcdload_cert'].each do |alias_name, cer_content|
    dcdload_cert_path = "#{node['cassandra_role']['ssl_dir']}/#{alias_name}.cer"
    file dcdload_cert_path do
      mode '0400'
      content cer_content
    end

    bash 'convert to pk12' do
      cwd node['cassandra_role']['ssl_dir']
      user 'root'
      code <<-EOH
      openssl pkcs12 -export -in #{cert_file}.pem -inkey #{cert_key_name} -passin pass:#{pass} -out #{node['hostname']}.p12 -name #{cert_file} -CAfile ca.crt -caname root -passout pass:#{pass}
      EOH
    end

    execute "import cert and key file as pk12 for #{cert_file}" do
      cwd node['cassandra_role']['ssl_dir']
      user 'root'
      command <<-EOH
      keytool -importkeystore -deststorepass #{pass} -destkeypass #{pass} -destkeystore #{node['hostname']}.keystore -srckeystore #{node['hostname']}.p12 -srcstoretype PKCS12 -srcstorepass #{pass} -alias #{cert_file}
      EOH
      not_if "keytool -v -list -destkeystore #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.keystore -alias #{cert_file} -deststorepass #{pass} | grep -i \'Alias name: #{cert_file}\'"
    end

    # Figure out the public key of the cert and export it
    bash 'export public key' do
      user 'root'
      code <<-EOH
      keytool -export -alias #{cert_file} -file #{cert_file_path} -keystore #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.keystore -srcstorepass #{pass} -deststorepass #{pass} -destkeypass #{pass}
      EOH
    end

    bash 'import public keys' do
      user 'root'
      code <<-EOH
      keytool -import -v -trustcacerts -alias #{cert_file} -file #{cert_file_path} -keystore #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.truststore -storepass #{pass} -noprompt && echo "true" > #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.imported
      keytool -import -v -trustcacerts -alias #{alias_name} -file #{dcdload_cert_path} -keystore #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.truststore -storepass #{pass} -noprompt && echo "true" > #{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.imported
      EOH
      not_if do
        File.exist?("#{node['cassandra_role']['ssl_dir']}/#{node['hostname']}.imported")
      end
    end
  end
end
