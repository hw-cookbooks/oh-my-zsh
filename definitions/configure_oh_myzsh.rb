define :configure_oh_my_zsh do

  # Fetch variables from params
  user_home = params[:user_home]
  theme = params[:theme] || node[:ohmyzsh][:theme]
  plugins = params[:plugins] || node[:ohmyzsh][:plugins]
  auto_update = !!params[:auto_update]

  template "#{user_home}/.zshrc" do
    source 'zshrc.erb'
    owner params[:name]
    group params[:name]
    variables(
        :theme => theme,
        :plugins => plugins,
        :auto_update => auto_update
    )
    action :create_if_missing
  end

  file "#{user_home}/.zshenv" do
    content 'DEBIAN_PREVENT_KEYBOARD_CHANGES=yes'
    owner params[:user]
    group params[:group]
    action :create_if_missing
  end if platform_family?('debian')

end
