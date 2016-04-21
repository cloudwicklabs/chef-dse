#
# Cookbook Name:: cassandra_cron
# Recipe:: default
# creater: balaji.ganapathi@target.com
#
#

include_recipe 'cron'

# create the nodetool_repair.sh file
template 'tmp/nodetool_repair.sh' do
  source 'nodetool_repair.sh.erb'
  owner 'root'
  mode 00755
end

at_minute = node['cassandra_role']['minute']
if at_minute.nil?
  at_minute = Random.rand(60)
  node.set['cassandra_role']['minute'] = at_minute
end

at_hour = node['cassandra_role']['hour']
if at_hour.nil?
  at_hour = Random.rand(4)
  node.set['cassandra_role']['hour'] = at_hour
end

on_day = node['cassandra_role']['day']
if on_day.nil?
  on_day = Random.rand(7)
  node.set['cassandra_role']['day'] = on_day
end

cron_d 'nodetool-repair-job' do
  minute at_minute
  hour at_hour
  weekday on_day
  command '/tmp/nodetool_repair.sh'
  user 'root'
end
