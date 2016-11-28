# # encoding: utf-8

# Inspec test for recipe jj_vault::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

unless os.windows?
  describe user('root') do
    it { should exist }
  end
end

describe port(8200) do
  it { should be_listening }
end

describe directory('/etc/vault') do
  it { should be_directory }
end

describe file('/usr/bin/vault') do
  it { should be_file }
end

describe systemd_service('vault') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/vault/settings.hcl') do
  it { should be_file }
end
