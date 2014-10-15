name             'glusterfs'
maintainer       'Joshua Farr'
maintainer_email 'josh@creativemarket.com'
license          'Apache 2.0'
description      'Installs and configures Gluster servers and clients'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.16'

recipe           'glusterfs::server', 	'Installs the gluster server components'
recipe           'glusterfs::client', 	'Installs the gluster client components'
recipe           'glusterfs::default',	'Installs the gluster client components'

depends          'apt'
depends          'yum'

suggests         'xfs'
