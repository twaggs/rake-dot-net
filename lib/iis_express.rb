class IISExpress
  attr_accessor :execution_path

  def initialize
    @execution_path = "C:\\Program Files (x86)\\IIS Express"

    @sh = CommandShell.new
  end

  def start(path, port)
    raise RuntimeError, "unable to find iis express at execution path: #{ @execution_path }" if !iis_express?

    @sh.execute command(path, port)
  end

  def iis_express?
    return File.exists? @execution_path
  end

  def command(path, port)
    return "start /d\"#{ execution_path }\" iisexpress /path:\"#{ path }\" /port:#{ port }"
  end
end
