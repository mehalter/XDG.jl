using Documenter

@info "Loading XDGSpec"
using XDGSpec, XDGSpec.BaseDirectory

@info "Building Documenter.jl docs"
makedocs(
  modules   = [XDGSpec],
  format    = Documenter.HTML(),
  sitename  = "XDGSpec.jl",
  doctest   = false,
  checkdocs = :none,
  pages     = Any[
    "XDGSpec.jl" => "index.md",
    "Base Directories" => "BaseDirectory.md"
  ]
)

@info "Deploying docs"
deploydocs(
  target = "build",
  repo   = "github.com/mehalter/XDGSpec.jl.git",
  branch = "gh-pages"
)
