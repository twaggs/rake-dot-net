require 'fileutils'

class WebBuilder
  attr_accessor :path, :source, :temp, :destination

  def initialize()
    @path = "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_compiler.exe"
    @temp = "#{Dir.pwd}\\temp\\"
    @destination = "c:\\inetpub\\wwwroot\\"
    @command_shell = CommandShell.new
  end

  def build()
    raise RuntimeError, "source (web project directory) doesn't exists or has not been specified" if !source?
    FileUtils.rm_rf(@temp)
    @command_shell.execute(build_command(source, destination))
  end

  def source?
    return File.directory? @source
  end

  def build_command(source, destination)
    return "\"#{path}\" \"#{temp}\" -u -v \"\/\" -p \"#{source}\""
  end
end
