#
# Cookbook Name:: oh-my-zsh
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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

include_recipe "git"
include_recipe "zsh"

# search for users
if Chef::Config[:solo]
    # support fnichol/chef-user method
    users = Array.new
    # loop the users set for the node
    node["users"].each do |u|
        # get that users data bag
        user = data_bag_item('users', u)
        # finds users with the zsh env
        # use the array string search method http://www.ruby-doc.org/core-1.9.3/String.html
        if !user["shell"].nil? and !user["shell"]['zsh'].nil?
            # add the user to the list to be configured
            users.push(user)
        end
    end
else
    # support opscode-cookbooks/users method
    # search users with the zsh shell
    users = search( :users, "shell:*zsh" )
end

users.each do |u|
  user_id = u["id"]
  user_home = u.has_key?("home").nil? ? "/home/#{user_id}" : u["home"]

  git "#{user_home}/.oh-my-zsh" do
    repository "https://github.com/robbyrussell/oh-my-zsh.git"
    reference "master"
    user user_id
    group user_id
    action :checkout
    not_if "test -d #{user_home}/.oh-my-zsh"
  end

  theme = data_bag_item( "users", user_id )["oh-my-zsh-theme"]

  template "#{user_home}/.zshrc" do
    source "zshrc.erb"
    owner user_id
    group user_id
    variables( :theme => ( theme || node[:ohmyzsh][:theme] ))
    action :create_if_missing
  end
end
