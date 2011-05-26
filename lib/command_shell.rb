class CommandShell
  def execute cmd
    puts cmd + "\n\n"

    str=""
    STDOUT.sync = true
    IO.popen(cmd+" 2>&1") do |pipe| 
      pipe.sync = true
      while s = pipe.gets
        str += s
      end
    end
    
    puts str + "\n\n"

    str
  end
end
