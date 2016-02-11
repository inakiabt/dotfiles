__SSH_CONFIG_HOSTS_SEPARATOR_START='#<!-- START - Do not remove this line -->'
__SSH_CONFIG_HOSTS_SEPARATOR_END='#<!-- END - Do not remove this line -->'
ssh_config_hosts() {
    sed -n "/${__SSH_CONFIG_HOSTS_SEPARATOR_START}/{:a;n;/${__SSH_CONFIG_HOSTS_SEPARATOR_END}/b;p;ba}" ~/.ssh/config
}

ssh_config_generate() {
    cat .ssh/setup.config
    echo $__SSH_CONFIG_HOSTS_SEPARATOR_START
    cat .ssh/hosts.config
    echo $__SSH_CONFIG_HOSTS_SEPARATOR_END
}