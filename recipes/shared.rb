git "/usr/src/oh-my-zsh" do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

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

  theme = data_bag_item( "users", user_id )["oh-my-zsh-theme"]

  link "#{user_home}/.oh-my-zsh" do
    to "/usr/src/oh-my-zsh"
    not_if "test -d #{user_home}/.oh-my-zsh"
  end

  template "#{user_home}/.zshrc" do
    source "zshrc.erb"
    owner user_id
    group user_id
    variables( :theme => ( theme || node[:ohmyzsh][:theme] ))
    action :create_if_missing
  end
end
