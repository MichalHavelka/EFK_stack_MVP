exec { 'install docker':
  command => 'curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh'
}

package { 'htop','dnsutils','net-tools':
  ensure => installed,
  require => Exec['apt-update']
}
 
service { 'ssh':
  ensure => running,
  enable => true
 }

service { 'docker':
  ensure => running,
  enable => true
}
