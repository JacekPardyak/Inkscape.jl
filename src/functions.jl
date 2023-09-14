using Printf

function greet_your_package_name()
    println("Hello Inkscape!")
end

function is_url(x)
  re = r"^https?://"
  occursin(re, x)
end

function inx_actions(input, actions, ext)
  input_file_path = tempname() * ".svg"
  if is_url(input)
    download(input, input_file_path)
  else
    cp(input, input_file_path)
  end
  inkscape = "inkscape"
  output = tempname() * ext
  command = "--shell" # or --batch-process
  actions = @sprintf "%s export-filename:%s;export-do" actions output
  actions = "--actions=" * actions
  read(`$inkscape $command $actions $input_file_path`, String)
  output
end

function inx_extension(input, inkscape_extension_name, ext)
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