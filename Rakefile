require "./lib/command_shell.rb"

task :default do
  sh = CommandShell.new

  sh.execute "rspec specs --fail-fast"
end
