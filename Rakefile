require 'rake'
require 'bundler'
Bundler.setup
Bundler.require(:default) if defined?(Bundler)
Dir["./chef_deploy.rb"].each {|file| require file }

task :hi do 
  desc "HI Welcome To RVM boostrap"
  print "please try 'rake --tasks' to see all task \n"
end

task :default  => [:hi]

 desc "deploy"
  task :deploy do
     
     deploy = AutoDeploy.new("config/config.yml","production")
     deploy.read_config
     deploy.do_scp_tasks
     puts "[INFO] chef_resources copy done successfully"
     deploy.run_ruby
     puts "[INFO]  chef  done successfully"
  end	
 
  
