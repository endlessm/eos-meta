project('eos-meta')

if get_option('check-deps')
  test('check-deps',
    find_program('eos-metapackage'),
    workdir : meson.current_source_dir(),
    args : [
      '--check-deps',
    ],
    env : [
      'DH_VERBOSE=1',
    ],
  )
endif
