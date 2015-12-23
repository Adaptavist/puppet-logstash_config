require 'spec_helper'
 
describe 'logstash_config', :type => 'class' do
  package_url = 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.3.3-1_centos.noarch.rpm'
  context "Should install logstash and adds config file to it" do
    let(:params) { {
        :package_url => package_url,
        :config_file => '/tmp/logstash.conf'
        } }
    let(:facts) {{
      :kernel => 'Linux',
      :operatingsystem => 'RedHat',
      }}
    it do
      should contain_class('logstash').with(
        'package_url'   => package_url,
        'status'        => 'running',
        'init_defaults' => { 
            'START' => 'true'
            },
        'ensure'        => 'present',
        'require'       => [],
        )
      should contain_logstash__configfile('logstash-config').with_source('/tmp/logstash.conf')
    end
    
  end
end
