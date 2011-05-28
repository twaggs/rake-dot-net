class CommandShell
  def execute cmd
    puts cmd
    str = ""
    STDOUT.sync = true
    IO.popen(cmd + " 2>&1") do |pipe| 
      pipe.sync = true
      while s = pipe.gets
        str += s
      end
    end
    puts str
    
    return str
  end
end
