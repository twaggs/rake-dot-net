require './command_shell.rb'
require './web_deploy.rb'
require './iis_express.rb'
require './sln_builder.rb'

task :rake_dot_net_initialize do
  @iis_express = IISExpress.new
  @web_deploy = WebDeploy.new
  @sh = CommandShell.new
  @sln = SlnBuilder.new
end

task :build => :rake_dot_net_initialize do |t, args|
  if(args[:sln])
    @sln.build args[:sln]
  else
    raise RuntimeError, 'You need to specify a solution file to the rake command: example rake -f rake-dot-net.rb build sln="SomeSolution.sln"'
  end
end

task :deploy => :rake_dot_net_initialize do |t, args|
  if(args[:src] && args[:des])
    @web_deploy.deploy args[:src], args[:des]
  else
    raise RuntimeError, 'You need to specify a source and destination diretory to the rake command: example rake -f rake-dot-net.rb deploy src="SomeMvcProject" des="c:\inetpub\wwwroot"'
  end

end

task :server => :rake_dot_net_initialize do |t, args|
  if(args[:dir] && args[:port])
    sh @iis_express.command args[:dir], args[:port]
  else
    raise RuntimeError, 'You need to specify a directory and port to the rake command: example rake -f rake-dot-net.rb server dir="c:\inetpub\somewebsite" port="3000"'
  end
end
