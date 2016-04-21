# default['physical']['volumes'] = ['/dev/xvdb', '/dev/xvdc']
# default['volume']['groups']['vg-data']['physical_volumes'] = node['physical']['volumes']

default['storage']['volumes'] = { # Needs to be overridden in environment variables
  'vol_apps_install' => {
    'size' => '1G',
    'mount' => '/apps/install',
    'group' => 'rootvg',
    'filesystem' => 'ext4'
  },
  'vol_apps_logs' => {
    'size' => '1G',
    'mount' => '/logs',
    'group' => 'rootvg',
    'filesystem' => 'ext4'
  }
  # 'vol_apps_data1' => {
  #   'size' => '745G',
  #   'mount' => '/data1',
  #   'group' => 'vg-data',
  #   'filesystem' => 'ext4'
  # },
  # 'vol_apps_data2' => {
  #   'size' => '745G',
  #   'mount' => '/data2',
  #   'group' => 'vg-data',
  #   'filesystem' => 'ext4'
  # }
}
