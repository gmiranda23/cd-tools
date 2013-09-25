#
# Cookbook Name:: apache-jenkins
# Recipe:: default
#
# Copyright 2013, Opscode Inc.
#
# All rights reserved - Do Not Redistribute
#

package "apache2" do
    action :install
end

execute "a2enmod http" do
  only_if do
    File.symlink?("/etc/apache2/mods-enabled/proxy.load")
  end
  notifies :restart, "service[apache2]"
end

execute "a2enmod http_proxy" do
  only_if do
    File.symlink?("/etc/apache2/mods-enabled/proxy_http.load")
  end
  notifies :restart, "service[apache2]"
end

execute "a2dissite default" do
  only_if do
    File.symlink?("/etc/apache2/sites-enabled/000-default")
  end
  notifies :restart, "service[apache2]"
end

template "/etc/apache2/sites-available/jenkins" do
  source "jenkins.erb"
  mode "0644"
    variables(
    :server_admin => node['apache-jenkins']['server_admin'],
    :server_name => node['apache-jenkins']['server_name'],
    :server_alias => node['apache-jenkins']['server_alias'],
    :proxy_port => node['apache-jenkins']['proxy_port'],
    :port => node['apache-jenkins']['port']
  )
  notifies :restart, "service[apache2]"
  end

execute "a2ensite jenkins" do
  not_if do
    File.symlink?("/etc/apache2/sites-enabled/jenkins")
  end
  notifies :restart, "service[apache2]"
end

service "apache2" do
    action [ :start, :enable ]
end
