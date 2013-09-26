#
# Cookbook Name:: cd-tools
# Recipe:: tools
#
# Copyright 2013, Opscode Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "jenkins"

# create up to 10 backups of the files, set the files owner different from the directory.
remote_directory "/var/lib/jenkins/tools" do
  source "tools"
  files_backup 10
  files_owner "root"
  files_mode "0755"
  owner "root"
  mode "0755"
end

# Drop off the jenkins configuration files
template "/var/lib/jenkins/config.xml" do
  source "config.xml.erb"
  owner "jenkins"
  group "jenkins"
  mode "0644"
end

template "/var/lib/jenkins/hudson.plugins.warnings.WarningsPublisher.xml" do
  source "hudson.plugins.warnings.WarningsPublisher.xml.erb"
  owner "jenkins"
  group "jenkins"
  mode "0644"
end

template "/var/lib/jenkins/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml" do
  source "hudson.plugins.warnings.WarningsPublisher.xml.erb"
  owner "jenkins"
  group "jenkins"
  mode "0644"
end


# Ensure pipeline jobs are present
if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  search(:chef_pipelines, "*:*") do |pipeline|
    %w{check-build promote-dev promote-staging promote-production}.each do |job_partial|
      job_directory = "/var/lib/jenkins/jobs/#{pipeline['id']}-#{job_partial}"

      directory job_directory do
        owner "jenkins"
        group "jenkins"
        mode "0755"
        recursive true
      end

      template File.join(job_directory, "config.xml") do
        source "#{job_partial}.xml.erb"
        owner "jenkins"
        group "jenkins"
        mode "0644"
        notifies :restart, "service[jenkins]"
        variables(:job => pipeline)
      end
    end
  end
end

# Create basic jenkins app users
# Install per pipeline job views
# Create generic ci-knife.rb
# Create generic berkshelf config
# Install org node keys
# Install github ssh key
