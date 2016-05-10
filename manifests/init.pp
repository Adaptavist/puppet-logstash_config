# = Class: logstash_forwarder_config
#
class logstash_config(
        $package_url = undef,
        $config_files = {},
        $ensure = 'present',
        $status = 'running',
        $repo_version = '1.4',
        $init_defaults = {
            'START' => 'true'
            },
        $pattern_files = {},
        $plugins       = {},
    ) {

    if defined(Class['elasticsearch']) {
        $dependencies = [Class['elasticsearch']]
    } else {
        $dependencies = []
    }

    create_resources(logstash::plugin, $plugins)
    
    if ($package_url and $package_url != 'false') {
        $manage_repo = false
        $real_package_url = $package_url
    } else {
        $manage_repo = true
        $real_package_url = undef
    }

    class {'logstash' :
        ensure        => $ensure,
        package_url   => $real_package_url,
        manage_repo   => $manage_repo,
        repo_version  => $repo_version,
        status        => $status,
        init_defaults => $init_defaults,
        require       => $dependencies,
    }

    $files_defaults = {
        before  => Service[$logstash::params::service_name],
        require => Package[$logstash::params::package],
    }

    # create any required config files
    validate_hash($config_files)
    create_resources(logstash::configfile, $config_files, $files_defaults)

    # create any required pattern files
    validate_hash($pattern_files)
    create_resources(logstash::patternfile, $pattern_files, $files_defaults)
}
