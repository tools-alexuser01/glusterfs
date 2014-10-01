glusterfs Cookbook
================
This cookbook is used to install and configure Gluster on both servers and clients. This cookbook makes several assumptions when configuring Gluster servers:

1. If using the cookbook to format disks, each disk will contain a single partition dedicated for Gluster
2. Non-replicated volume types are not supported
3. All peers for a volume will be configured with the same number of bricks

Requirements
------------
This cookbook has been tested on Ubuntu 12.04 and CentOS 6.5.

Attributes
----------

#### glusterfs::client
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['glusterfs']['client']['volumes'][VOLUME_NAME]['server']</tt></td>
    <td>String</td>
    <td>Server to connect to</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['client']['volumes'][VOLUME_NAME]['mount_point']</tt></td>
    <td>String</td>
    <td>Mount point to use for the Gluster volume</td>
    <td>None</td>
  </tr>
</table>

#### glusterfs::server
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes']['brick_mount_path']</tt></td>
    <td>String</td>
    <td>Default path to use for mounting bricks</td>
    <td>/gluster</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['disks']</tt></td>
    <td>Array</td>
    <td>An array of disks to create partitions on and format for use with Gluster, (for example, ['sdb', 'sdc'])</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['allowed_hosts']</tt></td>
    <td>Array</td>
    <td>An optional array of IP addresses to allow access to the volume</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['disks']</tt></td>
    <td>Array</td>
    <td>An optional array of disks to put bricks on (for example, ['sdb', 'sdc']); by default the cookbook will use the first x number of disks, equal to the replica count</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['lvm_volumes']</tt></td>
    <td>Array</td>
    <td>An optional array of logical volumes to put bricks on (for example, ['LogVolGlusterBrick1', 'LogVolGlusterBrick2']); by default the cookbook will use the first x number of volumes, equal to the replica count</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['peers']</tt></td>
    <td>Array</td>
    <td>An array of FQDNs for peers used in the volume</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['quota']</tt></td>
    <td>String</td>
    <td>An optional disk quota to set for the volume, such as '10GB'</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['replica_count']</tt></td>
    <td>Integer</td>
    <td>The number of replicas to create</td>
    <td>None</td>
  </tr>
  <tr>
    <td><tt>['glusterfs']['server']['volumes'][VOLUME_NAME]['volume_type']</tt></td>
    <td>String</td>
    <td>The volume type to use; currently 'replicated' and 'distributed-replicated' are the only types supported</td>
    <td>None</td>
  </tr>
</table>

Usage
-----

On two or more identical systems, attach the desired number of dedicated disks to use for Gluster storage. Create a role containing the glusterfs::server recipe for the gluster peers to use and add the appropriate attributes, such as volumes to the `['glusterfs']['server']['volumes']` attribute. If the cookbook will be used to manage disks, add the disks to the `['glusterfs']['server']['disks']` attribute; otherwise format the disks appropriately and add them to the `['glusterfs']['server']['volumes'][VOLUME_NAME]['disks']` attribute. Once all peers for a volume have configured their bricks, the 'master' peer (the first in the array) will create and start the volume.

For clients, create a role containing the gluster::default or glusterfs::client recipe, and add any volumes to mount to the `['glusterfs']['client']['volumes']` attribute. The Gluster volume will be mounted on the next chef-client run (provided the volume exists and is available) and added to /etc/fstab.


License and Authors
-------------------


Contributors:

- Joshua Farr <josh@creativemarket.com>

Based on `gluster` cookbook by:

- Biola University (https://github.com/biola/chef-cookbooks/tree/master/gluster)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.