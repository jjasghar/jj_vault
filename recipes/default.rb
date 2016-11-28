#
# Cookbook Name:: jj_vault
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

vault_version = node['jj_vault']['version']

# if 'debian' == node['platform_family']
#   include_recipe 'apt'
# end

package 'unzip'

remote_file "/tmp/vault_#{vault_version}_linux_amd64.zip" do
  source "https://releases.hashicorp.com/vault/#{vault_version}/vault_#{vault_version}_linux_amd64.zip"
  owner "root"
  group "root"
  mode "0644"

  action :create
end

bash "unzip the zip" do
  user "root"
  cwd "/tmp"
  creates "/tmp/vault-#{vault_version}"
  code <<-EOH
    STATUS=0
    unzip /tmp/vault_#{vault_version}_linux_amd64.zip || STATUS=1
    mv vault vault-#{vault_version}  || STATUS=1
    mv vault-#{vault_version} /usr/bin/ || STATUS=1
    exit $STATUS
  EOH
end

link "/usr/bin/vault" do
  to "/usr/bin/vault-#{vault_version}"
end

directory "/etc/vault" do
  owner "root"
  group "root"
  mode "0755"

  action :create
end

directory "/usr/lib/systemd/system/" do
  owner "root"
  group "root"
  mode "0755"

  action :create
end


template "/usr/lib/systemd/system/vault.service" do
  source "vault.service.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/vault/settings.hcl" do
  source "settings.hcl.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "vault" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end
