#
# Cookbook Name:: glusterfs
# Provider:: mount
#
# Copyright 2014, Creative Market
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/log'
require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
	true
end

action :create do
  if @current_resource.mounted?
    Chef::Log.info "#{ @new_resource } already mounted - nothing to do."
  else
    converge_by("Mount #{ @new_resource }") do
      mount_glusterfs_volume
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::GlusterfsMount.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.server(@new_resource.server)
  @current_resource.mount_point(@new_resource.mount_point)
end

private

def mount_glusterfs_volume
  include_recipe 'glusterfs::repository'

  # Install the client package
  package node['glusterfs']['client']['package']

  # Ensure the mount point exists
  directory new_resource.mount_point do
    recursive true
    action :create
  end

  # Mount the partition and add to /etc/fstab
  mount new_resource.mount_point do
    device "#{new_resource.server}:/#{new_resource.name}"
    fstype 'glusterfs'
    options 'defaults,_netdev'
    pass 0
    action [:mount, :enable]
  end
end

# mounted? check lifted from: https://github.com/opscode/chef/blob/master/lib/chef/provider/mount/mount.rb
def mounted?
  mounted = false

  # "mount" outputs the mount points as real paths. Convert
  # the mount_point of the resource to a real path in case it
  # contains symlinks in its parents dirs.
  real_mount_point = if ::File.exists? @new_resource.mount_point
                       ::File.realpath(@new_resource.mount_point)
                     else
                       @new_resource.mount_point
                     end

  shell_out!("mount").stdout.each_line do |line|
    case line
    when /^#{device_mount_regex}\s+on\s+#{Regexp.escape(real_mount_point)}\s/
      mounted = true
      Chef::Log.debug("Special device #{device_logstring} mounted as #{real_mount_point}")
    when /^([\/\w])+\son\s#{Regexp.escape(real_mount_point)}\s+/
      mounted = false
      Chef::Log.debug("Special device #{$~[1]} mounted as #{real_mount_point}")
    end
  end
  @current_resource.mounted(mounted)
end
