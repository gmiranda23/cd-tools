#!/opt/chef/embedded/bin/ruby
#
# Pin a given environment to the cookbook revisions in the current repository
#

require 'chef/environment'
require 'chef'

#Chef::Config.from_file(File.expand_path(File.join(ENV['WORKSPACE'], "ci-knife.rb")))
#Chef::Config.from_file("/var/lib/jenkins/tools/ci-knife.rb")
Chef::Config.from_file("/var/lib/jenkins/tools/ci-test-knife.rb")

def pin_env(env, cookbook_versions)
  to = Chef::Environment.load(env)
  cookbook_versions.each do |cb, version|
    puts "Pinning #{cb} #{version} in #{env}"
    to.cookbook_versions[cb] = version
  end
  to.save
end

cookbook_data = Array.new

if File.exists?(File.expand_path(File.join(ARGV[1], 'metadata.rb')))
  metadata_file = File.expand_path(File.join(ARGV[1], 'metadata.rb'))
  File.read(metadata_file).each_line do |line|
    if line =~ /^name\s+["'](\w+)["'].*$/
      cookbook_data << $1
    end
    if line =~ /^version\s+["'](\d+\.\d+\.\d+)["'].*$/
      cookbook_data << "= #{$1}"
    end
  end
end

cookbook_versions = Hash[*cookbook_data]

pin_env(ARGV[0], cookbook_versions)

