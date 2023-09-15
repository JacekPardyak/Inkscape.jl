function inx_install_lin()
  bat = tempname() * ".sh"
  text = "#!/bin/bash
sudo apt install -y software-properties-common > /dev/null 2>&1
sudo apt update > /dev/null 2>&1
sudo add-apt-repository -y ppa:inkscape.dev/stable > /dev/null 2>&1
sudo apt install -y inkscape > /dev/null 2>&1
inkscape --version"
  open(bat, "w") do file
    write(bat, text)
  end
  c1 = "chmod"; c2 =  "+x"
  run(`$c1 $c2 $bat`)
  run(`$bat`)
  println("Inkscape has been installed")
end

function inx_install_win()
  c1 = "winget"; c2 =  "install"; c3 = "-e"; c4 = "--id"; c5 = "Inkscape.Inkscape"
  run(`$c1 $c2 $c3 $c4 $c5`)
  println("Inkscape has been installed")
end

function inx_isurl(x)
  re = r"^https?://"
  occursin(re, x)
end

function inx_extension_lin(input, inkscape_extension_name, ext)
  input_file_path = tempname() * ".svg"
  if inx_isurl(input)
    download(input, input_file_path)
  else
    cp(input, input_file_path)
  end
  inkscape = "inkscape"
  command = "--system-data-directory"
  path = read(`$inkscape $command`, String)
  path = replace(path, "\n"=>"")
  inkscape_extension_path = path * "/extensions/" * inkscape_extension_name
  output = tempname() * ext
  bat = tempname() * ".sh"
  text = @sprintf "#!/bin/bash \n python3 \"%s\" --output=\"%s\" \"%s\"\n" inkscape_extension_path output input_file_path
  open(bat, "w") do file
    write(bat, text)
  end
  c1 = "chmod"; c2 =  "+x" 
  run(`$c1 $c2 $bat`)
  run(`$bat`)
  output
end

function inx_extension_win(input, inkscape_extension_name, ext)
  input_file_path = tempname() * ".svg"
  if is_url(input)
    download(input, input_file_path)
  else
    cp(input, input_file_path)
  end
  inkscape = "inkscape"
  command = "--system-data-directory"
  path = read(`$inkscape $command`, String)
  path = replace(path, "\n"=>"")
  inkscape_python_home  = replace(path, "\\share\\inkscape"=>"") * "\\bin"
  inkscape_extension_path = path * "\\extensions\\" * inkscape_extension_name 
  output = tempname() * ext
  bat = tempname() * ".bat"
  text = @sprintf "@ECHO OFF \n cd \"%s\" \n python.exe \"%s\" --output=\"%s\" \"%s\"\n" inkscape_python_home inkscape_extension_path output input_file_path
  open(bat, "w") do file
    write(bat, text)
  end
  run(`$bat`)
  output
end
