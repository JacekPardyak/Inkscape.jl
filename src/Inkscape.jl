module Inkscape

# utils
export inx_isurl
export inx_install_lin
export inx_install_win
export inx_extension_lin
export inx_extension_win
include("utils.jl")

# functions
import Printf
export inx_install
export inx_version
export inx_actions
export inx_extension
include("functions.jl")

end
