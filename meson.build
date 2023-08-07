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

test_1 = find_program('test_size_image_storage', 'tests/test_size_image_storage.py')

test(
  'mon_projet_tests',   # Nom de la cible de test
  test_1
)

subdir('src')

install_data(source_module)