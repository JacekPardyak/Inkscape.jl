module Inkscape

# utils
export inx_install_lin
export inx_install_win
include("utils.jl")

# functions
import Printf
export inx_install
export inx_version
export is_url
export inx_actions
export inx_extension
include("functions.jl")

end
