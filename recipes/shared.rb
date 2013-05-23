include_recipe "git"
include_recipe "zsh"

git node[:ohmyzsh][:shared_path] do
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

search( :users, "shell:*zsh" ).each do |u|
  user_id = u["id"]
  user_home = u["home"] ? u["home"] : "/home/#{user_id}"

  theme = data_bag_item( "users", user_id )["oh-my-zsh-theme"]

  link "#{user_home}/.oh-my-zsh" do
    to "/usr/src/oh-my-zsh"
    not_if "test -d #{user_home}/.oh-my-zsh"
  end

  template "#{user_home}/.zshrc" do
    source "zshrc.erb"
    owner user_id
    group user_id
    variables(
        :theme => ( theme || node[:ohmyzsh][:theme] ),
        :plugins => ( u['zsh_plugins'] || node[:ohmyzsh][:plugins])
    )
    action :create_if_missing
  end
end
