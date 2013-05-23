# Syncronize oh-my-zsh in the given path, call it with path argument
define :download_oh_my_zsh, :mode => :shared do

  # Base path for checkout
  base_path = params[:name]
  if params[:mode] == :user
    # Append hidden dir if mode is user
    base_path << '/.oh-my-zsh' if params[:mode] == :user
    # Sync or checkout according to given mode
    checkout_mode = :checkout
    # append guard to checkout
    guard_condition = "test -d #{base_path}/.oh-my-zsh"
  else
    # Update on following chef runs
    checkout_mode = :sync
    # always false guard
    guard_condition = 'false'
  end


  git base_path do
    repository 'https://github.com/robbyrussell/oh-my-zsh.git'
    reference 'master'
    user params[:user] if params[:user]
    group params[:group] if params[:group]
    action checkout_mode
    not_if guard_condition
  end

end
