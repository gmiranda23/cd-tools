name "jenkins"
description "Jenkins Server"
run_list [ "recipe[apt]", "recipe[build-essential]", "recipe[apache2]", "recipe[java]", "recipe[jenkins]", "recipe[foodcritic]", "recipe[berkshelf]", "recipe[cd-tools]" ]
default_attributes(
  'build_essential' => {
    'compiletime' => true
  },
  'jenkins' => {
    'http_proxy' => {
      'host_name' => "jenkins.local",
      'variant' => 'apache2'
    },
    'server' => {
      'plugins' => [ 'git', 'build-pipeline-plugin', 'github', 'ghprb', 'warnings', 'mailer' ]
    }
  },
  'cd-tools' => {
    'gerrit' => {
      'hostname' => "review.local",
      'front_end_url' => "http://review.local/"
    }
  }
)
