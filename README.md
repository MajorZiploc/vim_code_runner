# code_runner.vim

A vim/neovim plugin to run selected chunks of code or whole files. Can run locally or within docker or k8s containers

Use cases:
- light weight database client by executing chunks of code and respecting db env vars
- light weight redis client by executing chunks of commands and respecting redis env vars
- execute tagged code blocks in markdown files
- execute chunks of code or whole files for script langages

# Table of contents
1. [Examples](#examples)
2. [Supported editors](#supported_editors)
3. [Supported Runners](#supported_runners)
4. [Runner Options](#runner_options)
5. [Recommended Keybindings](#recommended_keybindings)
6. [Pointers](#pointers)
7. [Contribution Requests](#contribution_requests)
8. [Install](#install)

## Examples: <a id="examples"></a>

### SQL Client:

![SQL_CLIENT_GIF](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzY5ODIxMzdkOTc1MjIwZmQwY2M5MDdmNDcxYjE2OGQ5NDQwMDY2NSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/aECxRS51f1kZ1lstQN/giphy.gif)

### Markdown and Code files:

![MARKDOWN_AND_CODE_FILES]( https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWQ5ZjNiM2U1NmMzOTVhNTYzOWVkZDZlMTMxYWQwYjc0ZDUxY2I0YSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/EjSlgTi4JGwnpqV3OR/giphy.gif)

## Supported editors: <a id="supported_editors"></a>
- vim
- neovim

## Supported Runners (in order of runner search): <a id="supported_runners"></a>

### Extra condition for .sh files that can redirect to other runners:

If your `.sh` file starts with a shebang to use a different command and you select that line (or run the whole shell file), then an attempt to use said program will occur instead of using `sh`.

<table style="width:100%">

  <tr>
    <th>Runner</th>
    <th>Command</th>
  </tr>

  <tr>
    <td>sh</td>
    <td>sh</td>
  </tr>

  <tr>
    <td>pgsql</td>
    <td>psql</td>
  </tr>

  <tr>
    <td>redis</td>
    <td>redis-cli</td>
  </tr>

  <tr>
    <td>sqlite</td>
    <td>sqlite3</td>
  </tr>

  <tr>
    <td>mongodb</td>
    <td>mongosh</td>
  </tr>

  <tr>
    <td>mssql**(EXPERIMENTAL/UNTESTED)**</td>
    <td>sqlcmd</td>
  </tr>

  <tr>
    <td>mysql</td>
    <td>mysql</td>
  </tr>

  <tr>
    <td>zsh</td>
    <td>zsh</td>
  </tr>

  <tr>
    <td>bash</td>
    <td>bash</td>
  </tr>

  <tr>
    <td>cmd</td>
    <td>bat</td>
  </tr>

  <tr>
    <td>python</td>
    <td>python</td>
  </tr>

  <tr>
    <td>javascript</td>
    <td>node</td>
  </tr>

  <tr>
    <td>typescript</td>
    <td>ts-node</td>
  </tr>

  <tr>
    <td>php</td>
    <td>php</td>
  </tr>

  <tr>
    <td>ruby</td>
    <td>ruby</td>
  </tr>

  <tr>
    <td>perl</td>
    <td>perl</td>
  </tr>

  <tr>
    <td>powershell</td>
    <td>pwsh</td>
  </tr>

</table>

### How a runner is selected:

`g:vim_code_runner_runner_configs` runner ordered list drives the runner selection

### Add a runner

You can add a new runner by prepending or appending a runner to `g:vim_code_runner_runner_configs`

NOTE: the order of `g:vim_code_runner_runner_configs` is important. The first runner that matches the conditions in the function `_VCR_IsRunner` will be choosen

NOTE: you can also reorder `g:vim_code_runner_runner_configs` all together

---

## Runner Options: <a id="runner_options"></a>

```vim
" will run in the container if this is set to non empty string (Default: unset)
let vim_code_runner_container_name="container_name" |
" specify what kind of container you want to run in. Valid choices: ["docker", "k8s"] (Default: docker)
let vim_code_runner_container_type="docker" |
" Recommend using 'mechatroner/rainbow_csv' for the 'rfc_csv' filetype  (Default: csv)
let vim_code_runner_csv_type="rfc_csv" |
" will decide if sql output will be in csv format or the default for the sql cli tool being used (Default: true)
let vim_code_runner_sql_as_csv="true" |
" the number of  commands and query results saved (Default: 10) for array size of vim_code_runner_last_n_query_results
let vim_code_runner_history_size="10" |
" A label that will be prepended to all debug logs (Default: "DEBUG-> ")
let vim_code_runner_debug_label="DEBUG-> " |
" fallback file_type used in all runners (Default: "log")
let vim_default_file_type="log" |
```

NOTE: changing values of any of the `_vcr*` variables may lead to problems!

### Specific Runner Options: <a id="specific_runner_options"></a>

#### psql:

```vim
" the following are used only when vim_code_runner_container_name is not set
let $PGHOST="127.0.0.1" |
let $PGPORT="5432" |
" the following are used regardless
let $PGDATABASE="postgres" |
let $PGUSER="postgres" |
let $PGPASSWORD="password" |
```

#### sqlite:

```vim
" the following are used only when vim_code_runner_container_name is not set
let $SQLITEDBFILE="./main.sqlite" |
```

#### mssql:

`let vim_code_runner_sql_as_csv='false' |` is not supported

```vim
" the following are used only when vim_code_runner_container_name is not set
let $SQLCMDSERVER="127.0.0.1" |
let $SQLCMDPORT="5432" |
" the following are used regardless
let $SQLCMDDBNAME="mssql" |
let $SQLCMDUSER="mssql" |
let $SQLCMDPASSWORD="password" |
```

#### mysql:

```vim
let $MYSQLHOST="127.0.0.1" |
let $MYSQLPORT="5432" |
let $MYSQLDATABASE="mysql" |
let $MYSQLUSER="mysql" |
let $MYSQLPASSWORD="password" |
```

NOTE: `let vim_code_runner_sql_as_csv='true' |` is supported through a hack. Use `let vim_code_runner_sql_as_csv='false' |` if your query would have hard tab characters in the results. Commas from the values will be represented by ';' instead

#### mongodb:

```vim
let $MONGODBHOST="127.0.0.1" |
let $MONGODBPORT="5432" |
let $MONGODBUSER="mongodb" |
let $MONGODBPASSWORD="password" |
```

#### redis:

```vim
let $REDISHOST="127.0.0.1" |
let $REDISPORT="6379" |
```

## Recommended Keybindings: <a id="recommended_keybindings"></a>

```vim
" runs the selected_text with the determined run_type
vmap <leader>5 "ty:call VimCodeRunnerRun(@t)<CR>
" dry run / debug what VimCodeRunnerRun() will do in a real run
vmap <leader>4 "ty:call VimCodeRunnerRun(@t, '', 'true')<CR>
" run whole file
nmap <leader>5 ggVG"ty<c-o>:call VimCodeRunnerRun(@t)<CR>
" dry run / debug whole file if run_type supports it
nmap <leader>4 ggVG"ty<c-o>:call VimCodeRunnerRun(@t, '', 'true')<CR>
```

## Pointers: <a id="pointers"></a>

### I closed the results of my last query and the query takes a large amount of time to run.

there is a global variable called vim_code_runner_last_query_result; it stores the results of your last query

use something like this command to get the content out of the variable
```vim
" in visual mode with a blank line selected
put =g:vim_code_runner_last_query_result
```

you can view even further back depending on your vim_code_runner_history_size setting with vim_code_runner_last_n_query_results list

## Contribution Requests: <a id="contribution_requests"></a>

requesting MRs for other code runners
if they have specific runner env vars, then also update VimCodeRunnerRunConfigs to include a case for it

- some other sql???
- some other nosql???
- mysql improve csv format by removing the HACK
- consider using shellescape instead of substitute(raw_text, "'", "'\"'\"'", "g")

## Install: <a id="install"></a>

Use your plugin manager of choice such as vimplug or lazy as follows:

### VimPlug
```vim
call plug#begin('~/.vim/plugged')
" rest of your plugins ...
Plug 'MajorZiploc/code_runner.vim'
" rest of your plugins ...
call plug#end()
```

### Lazy (Example of Lazy being used inside of LunarVim)
```vim
lvim.plugins = {
  " rest of your plugins ...
  { "MajorZiploc/code_runner.vim" },
  " rest of your plugins ...
}
```

## Keywords:

sql_client, execute_code, execute_file, sql, redis, mongo, nosql, execute_code_block key_value_store_client
