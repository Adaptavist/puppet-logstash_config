require 'spec_helper'
 
describe 'logstash_config', :type => 'class' do
  package_url = 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.3.3-1_centos.noarch.rpm'
  context "Should install logstash and adds config file to it" do
    let(:params) { {
        :package_url => package_url,
        :config_files =>  { 'logstash-config' => { 'source' => '/tmp/logstash.conf' } },
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

  context "Should install logstash and adds pattern file to it" do
    let(:params) { {
        :package_url => package_url,
        :config_files =>  { 'logstash-config' => { 'source' => '/tmp/logstash.conf' } },
        :pattern_files => {  'pattern_file1' => { 'source' => 'puppet://files/pattern1' }, 'pattern_file2' => { 'source' => 'puppet://files/pattern2' } }
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
      should contain_logstash__patternfile('pattern_file1').with_source('puppet://files/pattern1')
      should contain_logstash__patternfile('pattern_file2').with_source('puppet://files/pattern2')
    end
    
  end
end
