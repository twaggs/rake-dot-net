require 'fileutils'

class WebBuilder
  attr_accessor :path, :source, :temp, :destination, :scrub

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

    FileUtils.rm project_files

    FileUtils.rm_rf(in_temp("Properties"))

    scrub.each { |f| FileUtils.rm_rf in_temp(f) } if !scrub.nil?
  end

  def project_files()
    return Dir.glob(in_temp("*.csproj*"))
  end

  def in_temp(pattern)
    return File.join(temp, pattern)
  end

  def source?
    return File.directory? @source
  end

  def build_command(source, destination)
    return "\"#{path}\" \"#{temp}\" -u -v \"\/\" -p \"#{source}\""
  end
end
