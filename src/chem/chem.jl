module Chem

import Base: start, done, next, read, parse, show, convert

using Compat

include("element.jl")
include("pdb.jl")

end
