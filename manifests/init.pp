# = Class: logstash_forwarder_config
#
class logstash_config(
        $package_url = undef,
        $config_file,
        $ensure = 'present',
        $status = 'running',
        $repo_version = '1.4',
        $init_defaults = {
            'START' => 'true'
            },
        $pattern_files = {},
    ) {

    if defined(Class['elasticsearch']) {
        $dependencies = [Class['elasticsearch']]
    } else {
        $dependencies = []
    }

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

    logstash::configfile {'logstash-config':
        source => $config_file,
    }

    $pattern_files_defaults = {
        before  => Service[$logstash::params::service_name],
        require => Package[$logstash::params::package],
    }
    validate_hash($pattern_files)
    create_resources(logstash::patternfile, $pattern_files, $pattern_files_defaults)
}
