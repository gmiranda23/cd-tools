#!/opt/chef/embedded/bin/ruby
require 'fileutils'

# Parse my options
require 'optparse'

options = {}
optparse = OptionParser.new do|opt|
  # Set a help banner
  opt.banner = "Usage: sync_env_repos.rb [options]"
  opt.separator  ""
  opt.separator  "Options"
  # Define the options
  opt.on("-e","--environment ENVIRONMENT","which environment you are updating") do |environment|
    options[:environment] = environment
  end
  opt.on("-g","--git GITFQDN","fqdn of git server") do |gitfqdn|
    options[:gitfqdn] = gitfqdn
  end
  opt.on("-r","--repo ORGREPO","name of git repo containing your environment definitions") do |orgrepo|
    options[:orgrepo] = orgrepo
  end
  opt.on("-o","--owner REPO_OWNER","name of ORGREPO owner") do |repo_owner|
    options[:repo_owner] = repo_owner
  end
  opt.on("-h","--help","display this page") do
    options[:help] = true
  puts optparse
  end
end
# parse
optparse.parse!


# TO-DO: grab all orgs, then pass to a .each method


# Clean stale repos if this job aborted abnormally
if options[:help]
  exit 0
else
  FileUtils.rm_rf("#{options[:orgrepo]}") if Dir.exist?("#{options[:orgrepo]}")

  if !system("git clone git@#{options[:gitfqdn]}:#{options[:repo_owner]}/#{options[:orgrepo]}.git")
    raise "Failed to checkout gmiranda-test"
  end

  if !system("knife environment show dev -Fj -c ~/tools/ci-test-knife.rb  > #{options[:orgrepo]}/environments/dev.json")
    raise "Failed to get current environment definition for dev"
  end

  if !system("cd #{options[:orgrepo]} ; git commit -a -m 'updated environment pinning from jenkins build'")
    raise "Failed to commit environment definition for dev"
  end

  if !system("cd #{options[:orgrepo]} ; git push origin master")
    raise "Failed to push updated environment to master"
  end
end
