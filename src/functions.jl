using Printf

function inx_install()
  @static if Sys.iswindows()
    inx_install_win()
  else
    inx_install_lin()
  end
end

function inx_version()
  inkscape = "inkscape"; command = "--version"
  read(`$inkscape $command`, String)
end

function inx_actions(input, actions, ext)
  input_file_path = tempname() * ".svg"
  if inx_isurl(input)
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
  @static if Sys.iswindows()
    inx_extension_win(input, inkscape_extension_name, ext)
  else
    inx_extension_lin(input, inkscape_extension_name, ext)
  end
end
