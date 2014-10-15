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
require 'chef/provider/mount/mount'

include Chef::Mixin::ShellOut

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  @new_resource.device = "#{new_resource.server}:/#{new_resource.name}" if @new_resource.device.nil?
  mount_provider = Chef::Provider::Mount::Mount.new(@new_resource, @run_context)
  if mount_provider.mounted?
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
  @run_context.include_recipe 'glusterfs::repository'

  # Install the client package
  package node['glusterfs']['client']['package']

  # Ensure the mount point exists
  directory new_resource.mount_point do
    recursive true
    action :create
  end

  # Mount the partition and add to /etc/fstab
  mount new_resource.mount_point do
    device new_resource.device
    fstype 'glusterfs'
    options 'defaults,_netdev'
    pass 0
    action [:mount, :enable]
  end
end
