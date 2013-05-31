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

search( :users, "shell:*zsh" ).each do |u|
  user_id = u["id"]
  user_home = u["home"] ? u["home"] : "/home/#{user_id}"

  download_oh_my_zsh user_home do
    mode :user
    user user_id
    group user_id
    # User exist on the system
    only_if "id #{user_id}"
  end

  configure_oh_my_zsh u['id'] do
    user_home user_home
    theme u['oh-my-zsh-theme']
    plugins u['zsh_plugins']
    auto_update node[:ohmyzsh][:auto_update]
  end
end
