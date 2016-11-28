#
# Cookbook Name:: jj_vault
# Recipe:: vault_ssh_helper
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'git'

bash "pull down vault-ssh-helper" do
  user "root"
  cwd "/root/"
  creates "/root/work/src/github.com/hashicorp/"
  code <<-EOH
  STATUS=0
    GOPATH=$HOME/work || STATUS=1
    mkdir -p $GOPATH/src/github.com/hashicorp/ || STATUS=1
    cd $GOPATH/src/github.com/hashicorp/ || STATUS=1
    git clone https://github.com/hashicorp/vault-ssh-helper.git || STATUS=1
  exit $STATUS
  EOH
end

require 'pry'; binding.pry

bash "build vault-ssh-helper" do
  user "root"
  cwd "/root/work/src/github.com/hashicorp/"
  creates "maybe"
  code <<-EOH
  STATUS=0
    GOPATH=$HOME/work || STATUS=1
    PATH=$PATH:$HOME/work/bin || STATUS=1
    cd vault-ssh-helper || STATUS=1
    make || STATUS=1
  exit $STATUS
  EOH
end

bash "install vault-ssh-helper" do
  user "root"
  cwd "/root/work/src/github.com/hashicorp/"
  creates "maybe"
  code <<-EOH
  STATUS=0
    GOPATH=$HOME/work || STATUS=1
    PATH=$PATH:$HOME/work/bin || STATUS=1
    make install || STATUS=1
  exit $STATUS
  EOH
end
