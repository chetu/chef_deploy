# deploy recipes

app = node[:deploy][:apps]
deploy_mode = node[:deploy][:deploy_mode]  

case "#{deploy_mode}"
 
when "init"
  cap_directories = [
    "#{app}/shared",
    "#{app}/shared/config",
    "#{app}/shared/config/log",
    "#{app}/shared/system",
    "#{app}/releases"
  ]
 
 cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      mode 0755
      recursive true
    end
  end

 git "#{app}/releases/#{Time.now.strftime("%Y%m%d%H%M")}" do
  repository "git@gitlab.betterlabs.net:chefblabs.git"
  reference "HEAD"
  action :sync
 end	

 link "#{app}/current" do
  to "#{app}/releases/#{Time.now.strftime("%Y%m%d%H%M")}"
 end
 
 execute "bundle" do
  cwd "#{app}/current"	
  command "bundle install"
  action :run
 end

 git "#{app}/current" do
  repository "git@gitlab.betterlabs.net:chefblabs.git"
  reference "HEAD"
  action :checkout
 end
 
directory "#{app}/current/log" do
    recursive true	
    action :delete
end

directory "#{app}/current/tmp" do
    recursive true
    action :create
end


link "#{app}/current/log" do
  to "#{app}/shared/config/log"
end
execute "touch" do
 command "touch #{app}/current/tmp/restart.txt"
 action :run
 creates "#{app}/current/tmp"
end

when "update"
 
 git "#{app}/current" do
  repository "git@gitlab.betterlabs.net:chefblabs.git"
  reference "HEAD"
  action :checkout
 end

 directory "#{app}/current/tmp" do
    recursive true
    action :create
 end

 execute "touch" do
 command "touch #{app}/current/tmp/restart.txt"
 action :run
 end

else
 puts "nthing"
end


