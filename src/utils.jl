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