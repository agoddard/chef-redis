#
# Cookbook Name:: redis
# Recipe:: server_source
#
# Copyright 2010, Atari, Inc
# Copyright 2012, CX, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


user node['redis']['user'] do
  gid node['redis']['group']
end

group node['redis']['group']



include_recipe "build-essential"

redis_source_tarball = "redis-#{node['redis']['source']['version']}.tar.gz"
redis_source_url = "#{node['redis']['source']['url']}/#{redis_source_tarball}"

%w[ src_dir dst_dir ].each do |dir|
  directory node['redis'][dir] do
    owner node['redis']['user']
    group node['redis']['group']
    action :create
  end
end

execute "install-redis" do
  cwd node['redis']['src_dir']
  command "make PREFIX=#{node['redis']['dst_dir']} install"
  creates "#{node['redis']['dst_dir']}/bin/redis-server"
  user node['redis']['user']
  action :nothing
end

execute "make-redis" do
  cwd node['redis']['src_dir']
  command "make"
  creates "redis"
  user node['redis']['user']
  action :nothing
  notifies :run, "execute[install-redis]", :immediately
end

execute "redis-extract-source" do
  command "tar zxf #{Chef::Config['file_cache_path']}/#{redis_source_tarball} --strip-components 1 -C #{node['redis']['src_dir']}"
  creates "#{node['redis']['src_dir']}/COPYING"
  only_if do File.exist?("#{Chef::Config['file_cache_path']}/#{redis_source_tarball}") end
  action :run
  notifies :run, "execute[make-redis]", :immediately
end

remote_file "#{Chef::Config['file_cache_path']}/#{redis_source_tarball}" do
  source redis_source_url
  mode 0644
  checksum node['redis']['source']['sha']
  notifies :run, "execute[redis-extract-source]", :immediately
end

template "redis_init" do
  path "/etc/init.d/redis-server"
  source "redis_init.erb"
  owner "root"
  group "root"
  mode 0755
end

service "redis-server" do
  action [ :enable, :start ]
end


