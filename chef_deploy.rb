#!/usr/bin/env ruby

require 'rubygems'
require 'logger'
require 'net/ssh'
require 'net/scp'
require 'net/sftp'
@@log = Logger.new( 'log/chef_deploy.log', 'daily' )
$CONF_FILE_NAME = ARGV[0]
$DEPLOYMENT_MODE = ARGV[1]
require 'yaml'
 class AutoDeploy
   attr_accessor :ip, :pass, :uname, :filename , :remote_webapps_path , :run_program ,:mod_name

   def initialize(config_name,deploy_mode)
    @config_name = config_name
    @deploy_mode = deploy_mode
   end

   
    def read_config
       	config = YAML.load_file("#{@config_name}")
	@uname = config["config"]["uname"]
	@ip = config["config"]["ip"]
	@pass = config["config"]["pass"]
	@filename = config["config"]["filename"]
	@mod_name = config["config"]["mod_name"]
        @run_program = config["config"]["run_program"]
        @remote_webapps_path= config["config"]["remote_webapps_path"]
   end
   def read_chef_attributes
       config = YAML.load_file("#{@config_name}")
       @deploy_mode =  config["attributes"]["deploy_mode"]	
   end 

  def run_ruby 
     Net::SSH.start("#{@ip}", "#{@uname}", :password => "#{@pass}" )  do |ssh|
      rest = ssh.exec("#{@run_program}")
      @@log.debug "Deploy: #{rest} => [#{Time.new}]"
     end
  end

  def do_scp_tasks
    Net::SCP.start("#{@ip}", "#{@uname}", :password => "#{@pass}" ) do |scp|
    scp = scp.upload!( "#{@filename}" , "#{@remote_webapps_path}" , :recursive => true )
    @@log.debug "Deploy: #{scp} => [#{Time.new}]"
    end
  end
 end


#@  Command line class call 

#deploy = AutoDeploy.new($CONF_FILE_NAME,$DEPLOY_MODE)
#deploy.read_config
#@git_var = deploy.mod_name
#puts deploy.mod_name
#deploy.do_scp_tasks
#puts "[INFO] chef_resources copy done successfully"
#deploy.run_ruby
#puts "[INFO]  chef  done successfully"

