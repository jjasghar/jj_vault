#
# Cookbook Name:: jj_vault
# Recipe:: vault_ssh_helper
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

go_version = node['jj_vault']['go_version']

remote_file "/tmp/go#{go_version}.linux-amd64.tar.gz" do
  source "https://storage.googleapis.com/golang/go#{go_version}.linux-amd64.tar.gz"
  owner "root"
  group "root"
  mode "0644"

  action :create
end

bash "untar go" do
  user "root"
  cwd "/tmp"
  creates "/usr/local/go/bin"
  code <<-EOH
  STATUS=0
  tar -C /usr/local -xzf /tmp/go#{go_version}.linux-amd64.tar.gz || STATUS=1
  exit $STATUS
  EOH
end

bash "add go to the path" do
  user "root"
  cwd "/tmp"
  creates "/root/.goSetUp"
  code <<-EOH
  STATUS=0
    echo 'export PATH=$PATH:/usr/local/go/bin' > /root/.bash_profile || STATUS=1
    touch $HOME/.goSetUp
  exit $STATUS
  EOH
end
