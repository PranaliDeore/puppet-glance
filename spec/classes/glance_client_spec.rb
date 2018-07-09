require 'spec_helper'

describe 'glance::client' do

  shared_examples 'glance client' do
    it { is_expected.to contain_class('glance::params') }
    it { is_expected.to contain_package('python-glanceclient').with(
        :name   => platform_params[:client_package_name],
        :ensure => 'present',
        :tag    => ['openstack', 'glance-support-package'],
      )
    }
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian'
            { :client_package_name => 'python3-glanceclient' }
          else
            { :client_package_name => 'python-glanceclient' }
          end
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :client_package_name => 'python3-glanceclient' }
          else
            { :client_package_name => 'python-glanceclient' }
          end
        end
      end

      it_configures 'glance client'
    end
  end
end
