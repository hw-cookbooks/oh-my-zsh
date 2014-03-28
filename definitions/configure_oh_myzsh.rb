define :configure_oh_my_zsh do

  # Fetch variables from params
  user_home = params[:user_home]
  theme = params[:theme] || node[:ohmyzsh][:theme]
  plugins = params[:plugins] || node[:ohmyzsh][:plugins]
  auto_update = !!params[:auto_update]
  # Overwrite config file if required
  file_action = node[:ohmyzsh][:keep_config] ? :create_if_missing : :create

  template "#{user_home}/.zshrc" do
    source 'zshrc.erb'
    owner params[:name]
    group params[:name]
    variables(
        :theme => theme,
        :plugins => plugins,
        :auto_update => auto_update
    )
    action file_action
    only_if "test -d #{user_home}"
  end

  file "#{user_home}/.zshenv" do
    content 'DEBIAN_PREVENT_KEYBOARD_CHANGES=yes'
    owner params[:user]
    group params[:group]
    action file_action
    only_if "test -d #{user_home}"
  end if platform_family?('debian')

end
