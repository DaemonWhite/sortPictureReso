project('picture-sorter',
          version: '0.0.3',
    meson_version: '>= 0.60',
  default_options: [ 'warning_level=2']
)

python = import('python')

py_installation = python.find_installation('python3')
py3_dep = dependency('python3', required : false)

source_module = files('src/pictureSorter.py')

if not py_installation.found()
    error('No valid python3 binary found')
endif

subdir('src')

install_data(source_module)