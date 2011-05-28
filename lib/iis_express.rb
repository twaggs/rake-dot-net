class IISExpress
  attr_accessor :execution_path

  def initialize
    @execution_path = "C:\\Program Files (x86)\\IIS Express\\iisexpress.exe"
  end

  def start
    raise RuntimeError, "unable to find iis express at execution path: #{ @execution_path }" if !iis_express?
  end

  def iis_express?
    return File.exists? @execution_path
  end
end
