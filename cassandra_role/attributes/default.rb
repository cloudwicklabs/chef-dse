override['cassandra']['dse_version'] = '4.0.3-1'
override['cassandra']['cluster_name'] = ''
# override['cassandra']['data_dir'] = ['/data1',
#                                      '/data2']
override['cassandra']['log_dir'] = '/var/log/cassandra/'
default['cassandra']['root_dir'] = '/var/lib/cassandra/'
default['cassandra']['commit_dir'] = '/data1/commitlog'
default['cassandra']['saved_cache_dir'] = '/data1/saved_cache'
override['cassandra']['dse']['delegated_snitch'] = 'org.apache.cassandra.locator.GossipingPropertyFileSnitch'
override['cassandra']['authentication'] = true
override['cassandra']['authorization']  = true
override['cassandra']['authenticator']  = 'org.apache.cassandra.auth.PasswordAuthenticator'
override['cassandra']['authorizer']     = 'org.apache.cassandra.auth.CassandraAuthorizer'

# Override Cassandra attributes
override['cassandra']['concurrent_writes'] = 64

# Override cassandra_cw attributes
override['cassandra_cw']['phi_convict_threshold'] = 12
# override['cassandra_cw']['product_name'] = 'cassandra'

# enable ssl for cassandra
override['cassandra_cw']['client_node_encryption'] = true
override['cassandra_cw']['client_auth'] = false
override['cassandra_cw']['internode_encryption'] = 'all'

default['cassandra_role']['cert'] = '/etc/cassandra/1.cer'
default['cassandra_role']['test'] = 'test'
default['cassandra_role']['cassandra_ssl_databag'] = 'cassandra_ssl_cert_dev'
default['cassandra_role']['cassandra_pass'] = 'cassandra_ddn_dev'
default['cassandra_role']['ssl_dir'] = '/etc/cassandra'
default['cassandra_role']['rmi_port'] = 9454
default['cassandra_role']['datacenter'] = ''
default['cassandra_role']['BackupIndex'] = '10'

# nodetool repair
default['cassandra_repair']['sh_file'] = 'tmp/nodetool_repair.sh'
default['cassandra_role']['minute'] = nil
default['cassandra_role']['hour'] = nil
default['cassandra_role']['day'] = nil

# Java policy jar paths for ssl clinet to node
default['java']['8']['policy_files_src'] = "/path/to/java/jce_policy-8.zip"
default['java']['8']['policy_unzip_folder_name'] = 'UnlimitedJCEPolicyJDK8'

# Override sensu attributes for logging
override['sensu']['sensu']['additional_client_attributes']['app_name'] = 'cw-cassandra'
override['sensu']['sensu']['additional_client_attributes']['app_tier'] = 'cassandra'

default['sensu']['metric_prefix']['app_name'] = 'cw-cassandra'
default['sensu']['metric_prefix']['app_tier'] = 'cassandra'

default['cassandra_role']['dse_repo_url'] = 'http://rpm.datastax.com/community'

# opscenter attributes
default['cassandra_role']['opscenter'] = 'opscenter-cassandra'
default['cassandra_role']['datastax-agent-conf'] = '/var/lib/datastax-agent/conf'
override['consul']['service_user'] = 'root'
