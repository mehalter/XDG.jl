""" BaseDirectory

This module provides a way for applications to locate
shared data and configureation based on

https://specifications.freedesktop.org/basedir-spec/latest/

(based on version 0.7)
"""
module BaseDirectory

export xdg_data_home, xdg_data_dirs, xdg_config_home, xdg_config_dirs,
       xdg_cache_home, save_config_path, save_data_path, save_cache_path,
       load_config_paths, load_data_paths, get_runtime_dir

"""
`\$XDG_DATA_HOME` or the default, `~/.local/share`
"""
xdg_data_home = get(ENV, "XDG_DATA_HOME", joinpath(Sys.homedir(), ".local", "share"))

"""
A list of directory paths in which application data may be stored, in preference order.
"""
xdg_data_dirs = [xdg_data_home;
                 filter(!isempty, split(get(ENV, "XDG_DATA_DIRS", "/usr/local/share:/usr/share"), ":"))]
"""
`\$XDG_CONFIG_HOME` or the default, `~/.config`
"""
xdg_config_home = get(ENV, "XDG_CONFIG_HOME", joinpath(Sys.homedir(), ".config"))

"""
A list of directory paths in which configuration may be stored, in preference order.
"""
xdg_config_dirs = [xdg_config_home;
                   filter(!isempty, split(get(ENV, "XDG_CONFIG_DIRS", "/etc/xdg"), ":"))]

"""
`\$XDG_CACHE_HOME` or the default, `~/.cache`
"""
xdg_cache_home = get(ENV, "XDG_CACHE_HOME", joinpath(Sys.homedir(), ".cache"))

"""
    save_path(base, resource...)

helper function to ensure path exists from a specific base directory
"""
function save_path(base, resource...)
  resource = joinpath(resource...)

  @assert(!startswith(resource, "/"), "path cannot be absolute")

  path = joinpath(base, resource)
  mkpath(path)
  return path
end

"""
    save_config_path(resource...)

Ensure `\$XDG_CONFIG_HOME/<resource>/` exists, and return its path.
'resource' should normally be the name of your application. Use
this when saving configuration settings.
"""
save_config_path(resource...) = save_path(xdg_config_home, resource...)

"""
    save_data_path(resource...)

Ensure `\$XDG_DATA_HOME/<resource>/` exists, and return its path.
'resource' should normally be the name of your application or a
shared resource. Use this when saving or updating application data.
"""
save_data_path(resource...) = save_path(xdg_data_home, resource...)

"""
    save_cache_path(resource...)

Ensure `\$XDG_CACHE_HOME/<resource>/` exists, and return its path.
'resource' should normally be the name of your application or a
shared resource.
"""
save_cache_path(resource...) = save_path(xdg_cache_home, resource...)

"""
    load_paths(bases::Array{String}, resource...)

helper function to load the same subdirectories from a list of base directories
"""
load_paths(bases, resource...) = Channel() do c
  resource = joinpath(resource...)
  for dir in bases
    path = joinpath(dir, resource)
    if ispath(path)
      push!(c, path)
    end
  end
end

"""
    load_config_paths(resource...)

Returns an iterator which gives each directory named 'resource' in the
configuration search path. Information provided by earlier directories should
take precedence over later ones, and the user-specific config dir comes first.
"""
load_config_paths(resource...) = load_paths(xdg_config_dirs, resource...)

"""
    function load_first_config(resource...)

Returns the first result from load_config_paths, or None if there is nothing to load.
"""
function load_first_config(resource...)
  for config in load_config_paths(resource...)
    return config
  end
  return Nothing
end

"""
    load_data_paths(resource...)

Returns an iterator which gives each directory named 'resource' in the
application data search path. Information provided by earlier directories
should take precedence over later ones.
"""
load_data_paths(resource...) = load_paths(xdg_data_dirs, resource...)

"""
    get_runtime_dir()
Returns the value of `\$XDG_RUNTIME_DIR`, a directory path.

This directory is intended for 'user-specific non-essential runtime files
and other file objects (such as sockets, named pipes, ...)', and
'communication and synchronization purposes'.
"""
function get_runtime_dir()
  return ENV["XDG_RUNTIME_DIR"]
end

end
