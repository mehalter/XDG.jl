# Base Directories

```@meta
CurrentModule = XDGSpec.BaseDirectory
```

The [XDG Base Directory
Speicification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
provides standard locations to store application data, configuration, and cached
data.

## Data directories

```@docs
save_data_path
load_data_paths
xdg_data_home
xdg_data_dirs
```

## Configuration directories

```@docs
save_config_path
load_config_paths
load_first_config
xdg_config_home
xdg_config_dirs
```

## Cache directory

```@docs
save_cache_path
xdg_cache_home
```

## Runtime directory

```@docs
get_runtime_dir
```
