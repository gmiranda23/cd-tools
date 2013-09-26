#
# Cookbook Name:: cd-tools
# Recipe:: jenkins_server
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
#

include_recipe "build-essential"
include_recipe "apache2"
include_recipe "java"
include_recipe "git"

node.default['jenkins']['server']['home'] = "/var/lib/jenkins"
node.default['jenkins']['http_proxy']['host_name'] = "jenkins.local"
node.default['jenkins']['http_proxy']['variant'] = "apache2"
node.default['jenkins']['server']['plugins'] = [ 'git', 'build-pipeline-plugin', 'github', 'ghprb', 'warnings', 'mailer' ]
include_recipe "jenkins"

include_recipe "virtualbox" unless Chef::Config[:solo]  # using solo to flag test-kitchen runs

node.default['vagrant']['url'] = "http://files.vagrantup.com/packages/db8e7a9c79b23264da129f55cf8569167fc22415/vagrant_1.3.3_x86_64.deb"
node.default['vagrant']['checksum'] = "d521858bd025ee79705495b00cc64eb88de3fe990dec6bda8a6b7382f9272153"
include_recipe "vagrant"

include_recipe "kitchen-jenkins"
include_recipe "berkshelf"
include_recipe "cd-tools::tools"
