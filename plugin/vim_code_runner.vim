function _VimCodeRunnerRunPsql(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    echohl WarningMsg
    echo "No selected_text stored in the t register! run_type: 'pgsql' does not support this"
    echohl None
    return []
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _psql = 'psql '
  if (get(g:, 'vim_code_runner_sql_as_csv', 'true') == 'true')
    let _psql = _psql . '--csv '
    let _file_type = get(g:, 'vim_code_runner_csv_type', 'csv')
  endif
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  if (a:is_in_container)
    if (get(g:, 'use_runner_options_in_container', "false") == 'true')
      let _command_prepend = 'export PGDATABASE=' . $PGDATABASE . '; '
            \ . 'export PGUSER=' . $PGUSER . '; '
            \ . 'export PGPASSWORD=' . $PGPASSWORD . '; '
      let _command = _psql . '-c "' . _preped_text . '"'
    else
      let _command = _psql . "-c '" . _preped_text . "'"
    endif
  else
    if (a:debug == 'true')
      echo a:debug_label "local PG* configs that will be used since not running in a container:"
      echo a:debug_label "  export PGHOST=\"".$PGHOST."\";"
      echo a:debug_label "  export PGPORT=\"".$PGPORT."\";"
      echo a:debug_label "  export PGDATABASE=\"".$PGDATABASE."\";"
      echo a:debug_label "  export PGUSER=\"".$PGUSER."\";"
      echo a:debug_label "  export PGPASSWORD=\"".$PGPASSWORD."\";"
    endif
    let _command = _psql . "-c '" . _preped_text . "'"
  endif
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunPython(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "python -c '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunJavascript(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "node -e '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunTypescript(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "ts-node -e '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunPhp(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _preped_text = substitute(_preped_text, "^\s*<\?php", "", "")
  let _preped_text = substitute(_preped_text, "\?>\s*", "", "")
  let _command = "php -r '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunRuby(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "ruby -e '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunPerl(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "perl -e '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction

function _VimCodeRunnerRunSh(selected_text, is_in_container, debug, debug_label)
  let raw_text = a:selected_text
  if (trim(raw_text) == '')
    execute 'normal! ggVG"ty'
    let raw_text = @t
  endif
  let _command_prepend = ''
  let _file_type = 'log'
  let _preped_text = substitute(raw_text, "'", "'\"'\"'", "g")
  let _command = "sh -c '" . _preped_text . "'"
  let _should_bottom_split = 1
  return [l:_command, l:_should_bottom_split, l:_command_prepend, l:_file_type]
endfunction


function! VimCodeRunnerRun(...)
  let run_type = get(a:, 1, '')
  let debug = get(a:, 2, 'false')
  let debug_label = "DEBUG-> "
  let _default_file_type = "text"
  " assumes the selected text will be yanked into the t register prior to VimCodeRunnerRun
  let selected_text = @t
  if (debug == 'true')
    echo debug_label "selected_text: " selected_text
  endif
  let case_values = []
  let is_in_container = !empty(get(g:, 'container_name', "")) && trim(g:container_name) != ''
  let _should_bottom_split = 0
  " check file_extension
  if (expand('%:e') == 'pgsql' || run_type == 'pgsql')
    let run_path = "pgsql"
    let case_values = _VimCodeRunnerRunPsql(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'python' || run_type == 'python')
    let run_path = "python"
    let case_values = _VimCodeRunnerRunPython(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'javascript' || run_type == 'javascript')
    let run_path = "javascript"
    let case_values = _VimCodeRunnerRunJavascript(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'typescript' || run_type == 'typescript')
    let run_path = "typescript"
    let case_values = _VimCodeRunnerRunTypescript(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'php' || run_type == 'php')
    let run_path = "php"
    let case_values = _VimCodeRunnerRunPhp(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'ruby' || run_type == 'ruby')
    let run_path = "ruby"
    let case_values = _VimCodeRunnerRunRuby(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'perl' || run_type == 'perl')
    let run_path = "perl"
    let case_values = _VimCodeRunnerRunPerl(selected_text, is_in_container, debug, debug_label)
  elseif (&filetype == 'sh' || run_type == 'sh')
    let run_path = "sh"
    let case_values = _VimCodeRunnerRunSh(selected_text, is_in_container, debug, debug_label)
  else
    echohl WarningMsg
    echo "No matching run_path!"
    echohl None
  endif
  let _command = get(case_values, 0, '')
  let _should_bottom_split = get(case_values, 1, 0)
  let _command_prepend = get(case_values, 2, '')
  let _file_type = get(case_values, 3, _default_file_type)
  let _base_command = _command
  if (is_in_container)
    let _command = "docker exec \"" . g:container_name . '" '
    if (!empty(get(l:, '_command_prepend', '')))
      let _shell_command = "sh -c '"
            \ . _command_prepend
            \ . _base_command
            \ . "'"
      let _command = _command . _shell_command
    else
      let _command = _command . _base_command
    endif
  endif
  if (trim(_base_command) == '')
    echohl WarningMsg
    echo "No _base_command could be generated for your specific use case"
    echo "run_path: " get(l:, 'run_path', '')
    echo "_base_command: " get(l:, '_base_command', '')
    echohl None
    return
  endif
  if (debug != 'true')
    let g:my_query_results = system(_command)
    if (_should_bottom_split)
      set splitbelow
      horizontal belowright Scratch
      put =g:my_query_results
      let &filetype = _file_type
      execute "normal! ggdd"
      set splitbelow!
    else
      put =g:my_query_results
    endif
  else
    echo debug_label "run_path: " run_path
    echo debug_label "_command: " _command
    echo debug_label "_command_prepend: " _command_prepend
    echo debug_label "_should_bottom_split: " _should_bottom_split
  endif
endfunction

function! _VimCodeRunnerRunConfigsPsql(...)
  let show_secrets = get(a:, 1, 0)
  let is_in_container = !empty(get(g:, 'container_name', "")) && trim(g:container_name) != ''
  if (is_in_container)
    echo "container_name=" . '"' . g:container_name . '";'
  endif
  if (!empty(get(g:, 'use_runner_options_in_container', "")))
    echo "use_runner_options_in_container=" . '"' . g:use_runner_options_in_container . '";'
  endif
  if (is_in_container && get(g:, 'use_runner_options_in_container', "false") == 'true')
    echohl WarningMsg
    echo "NOTE: since container_name is set and use_runner_options_in_container='true'; PGUSER, PGPASSWORD, and PGDATABASE env vars will be used"
    echohl None
  elseif (is_in_container)
    echohl WarningMsg
    echo "NOTE: since container_name is set without use_runner_options_in_container='true'; PG* env vars wont be used"
    echohl None
  elseif (get(g:, 'use_runner_options_in_container', "false") == 'true')
    echohl WarningMsg
    echo "NOTE: since use_runner_options_in_container='true' without container_name being set; it will take no effect"
    echohl None
  endif
  echo "export PGHOST=" . '"' . $PGHOST . '";'
  echo "export PGPORT=" . '"' .  $PGPORT . '";'
  echo "export PGDATABASE=" . '"' .  $PGDATABASE . '";'
  echo "export PGUSER=" . '"' . $PGUSER . '";'
  let _password = "<OMITTED> pass 1 as first arg to see it"
  if (show_secrets != 0)
    let _password = $PGPASSWORD
  endif
  echo "export PGPASSWORD=" . '"' .  _password . '";'
endfunction

function! VimCodeRunnerRunConfigs(...)
  let config_type = get(a:, 1, '')
  let rest_of_args = a:000[1:]
  if (config_type == 'pgsql')
    call call('_VimCodeRunnerRunConfigsPsql', rest_of_args)
  else
    echohl WarningMsg
    echo "Invalid config_type: " config_type
    echo "Valid config_types: ['pgsql']"
    echohl None
  endif
endfunction
