#
# Cookbook Name:: glusterfs
# Recipe:: repository
#
# Copyright 2013, Biola University
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

case node['platform']
when 'ubuntu', 'debian'
  apt_repository 'ubuntu-glusterfs' do
    uri "http://ppa.launchpad.net/gluster/glusterfs-#{node['glusterfs']['version']}/ubuntu"
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '774BAC4D'
    deb_src true
    not_if do
      File.exist?("/etc/apt/sources.list.d/ubuntu-glusterfs-#{node['glusterfs']['version']}.list")
    end
  end
when 'redhat', 'centos', 'amazon', 'scientific'
  yum_repository 'glusterfs' do
    url "http://download.gluster.org/pub/gluster/glusterfs/#{node['glusterfs']['version']}/LATEST/EPEL.repo/epel-$releasever/$basearch/"
    action :create
  end
end
