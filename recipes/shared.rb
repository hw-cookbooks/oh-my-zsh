include_recipe "git"
include_recipe "zsh"

download_oh_my_zsh node[:ohmyzsh][:shared_path] do
  mode :shared
end

search( :users, "shell:*zsh" ).each do |u|
  user_id = u["id"]
  user_home = u["home"] ? u["home"] : "/home/#{user_id}"

  link "#{user_home}/.oh-my-zsh" do
    to node[:ohmyzsh][:shared_path]
    # User exist on the system
    only_if "id #{user_id}"
  end

  configure_oh_my_zsh u['id'] do
    user_home user_home
    theme u["oh-my-zsh-theme"]
    plugins u['zsh_plugins']
    auto_update false # Shared copy should not be auto updated by users
  end

end
