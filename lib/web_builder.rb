class WebBuilder
  attr_accessor :path, :source, :temp, :destination

  def initialize()
    @path = "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_compiler.exe"
    @temp = "#{Dir.pwd}\\temp\\"
    @destination = "c:\\inetpub\\wwwroot\\"
  end

  def build()
    raise RuntimeError, "source (web project directory) doesn't exists or has not been specified" if !source?
    File.rm_rf(@temp)
    File.rm_rf(@destination)
  end

  def source?
    return File.directory? @source
  end
end
