#
# Cookbook Name:: berkshelf
# Recipe:: default
#
# Copyright 2013, Opscode Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential"

package "libxml2-dev"
package "libxslt-dev"

gem_package "berkshelf" do
  gem_binary "/opt/chef/embedded/bin/gem"
end
