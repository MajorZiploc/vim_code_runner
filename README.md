# vim_code_runner

Run selected chunks of code. Can run locally or within docker or k8s containers

Useful as a light weight database client

## Supported Runners

<table style="width:100%">

  <tr>
    <th>Runner</th>
    <th>Command</th>
    <th>Condition for using this Runner</th>
  </tr>

  <tr>
    <td>pgsql</td>
    <td>psql</td>
    <td>expand('%:e') == 'pgsql' || run_type == 'pgsql'</td>
  </tr>

  <tr>
    <td>python</td>
    <td>python</td>
    <td>&filetype == 'python' || run_type == 'python'</td>
  </tr>

  <tr>
    <td>javascript</td>
    <td>node</td>
    <td>&filetype == 'javascript' || run_type == 'javascript'</td>
  </tr>

  <tr>
    <td>typescript</td>
    <td>ts-node</td>
    <td>&filetype == 'typescript' || run_type == 'typescript'</td>
  </tr>

  <tr>
    <td>php</td>
    <td>php</td>
    <td>&filetype == 'php' || run_type == 'php'</td>
  </tr>

  <tr>
    <td>ruby</td>
    <td>ruby</td>
    <td>&filetype == 'ruby' || run_type == 'ruby'</td>
  </tr>

  <tr>
    <td>perl</td>
    <td>perl</td>
    <td>&filetype == 'perl' || run_type == 'perl'</td>
  </tr>

  <tr>
    <td>sh</td>
    <td>sh</td>
    <td>&filetype == 'sh' || run_type == 'sh'</td>
  </tr>

  <tr>
    <td>powershell</td>
    <td>pwsh</td>
    <td>&filetype == 'ps1' || run_type == 'powershell'</td>
  </tr>

  <tr>
    <td>mssql**(EXPERIMENTAL/UNTESTED)**</td>
    <td>sqlcmd</td>
    <td>expand('%:e') == 'mssql' || run_type == 'mssql'</td>
  </tr>

  <tr>
    <td>mysql**(EXPERIMENTAL/UNTESTED)**</td>
    <td>mysql</td>
    <td>expand('%:e') == 'mysql' || run_type == 'mysql'</td>
  </tr>

  <tr>
    <td>mongodb**(EXPERIMENTAL/UNTESTED)**</td>
    <td>mongodb</td>
    <td>expand('%:e') == 'mongodb' || run_type == 'mongodb'</td>
  </tr>

</table>

---

## Runner Options

```vim
" will run in the container if this is set to non empty string (Default: unset)
let container_name="container_name" |
" specify what kind of container you want to run in. Valid choices: ["docker", "k8s"] (Default: docker)
let container_type="docker"
" will use specific runner env vars (if applicable) in the container (Default: false)
let use_runner_options_in_container="true" |
" Recommend using 'mechatroner/rainbow_csv' for the 'rfc_csv' filetype  (Default: csv)
let vim_code_runner_csv_type="rfc_csv" |
" will decide if sql output will be in csv format or the default for the sql cli tool being used (Default: true)
let vim_code_runner_sql_as_csv="true" |
```

## Tips

### I closed the results of my last query and the query takes a large amount of time to run.

there is a global variable called vim_code_runner_query_results; it stores the results of your last query

use something like this command to get the content out of the variable
```vim
" in visual mode with a blank line selected
put =g:vim_code_runner_query_results
```

### Specific Runner Options

#### psql

```vim
" the following are used only when container_name is not set
let $PGHOST="127.0.0.1" |
let $PGPORT="5432" |
" the following are used regardless
let $PGDATABASE="postgres" |
let $PGUSER="postgres" |
let $PGPASSWORD="password" |
```

#### mssql

`let vim_code_runner_sql_as_csv='false' |` is not supported
`let use_runner_options_in_container='false' |` is not supported

```vim
" the following are used only when container_name is not set
let $SQLCMDSERVER="127.0.0.1" |
let $SQLCMDPORT="5432" |
" the following are used regardless
let $SQLCMDDBNAME="mssql" |
let $SQLCMDUSER="mssql" |
let $SQLCMDPASSWORD="password" |
```

#### mysql

`let vim_code_runner_sql_as_csv='false' |` is not supported
`let use_runner_options_in_container='false' |` is not supported

```vim
let $MYSQLHOST="127.0.0.1" |
let $MYSQLPORT="5432" |
let $MYSQLDATABASE="mysql" |
let $MYSQLUSER="mysql" |
let $MYSQLPASSWORD="password" |
```

#### mongodb

`let use_runner_options_in_container='false' |` is not supported

```vim
let $MONGODBHOST="127.0.0.1" |
let $MONGODBPORT="5432" |
let $MONGODBDATABASE="mongodb" |
let $MONGODBUSER="mongodb" |
let $MONGODBPASSWORD="password" |
```

## Recommended Keybindings

The t register is used to get the selected_text and use in the Run command

NOTE: the clearing of the t register at the beginning of the whole file commands is important to clean up state for running whole files

```vim
" runs the selected_text with the determined run_type
vmap <leader>5 "ty:call VimCodeRunnerRun()<CR>
" dry run / debug what VimCodeRunnerRun() will do in a real run
vmap <leader>4 "ty:call VimCodeRunnerRun('', 'true')<CR>
" run whole file if run_type supports it
nmap <leader>5 :let @t = ''<CR>:call VimCodeRunnerRun()<CR>
" dry run / debug whole file if run_type supports it
nmap <leader>4 :let @t = ''<CR>:call VimCodeRunnerRun('', 'true')<CR>
```

## Contribution Requests

requesting MRs for other code runners
if they have specific runner env vars, then also update VimCodeRunnerRunConfigs to include a case for it

- some other sql???
- some other nosql???
