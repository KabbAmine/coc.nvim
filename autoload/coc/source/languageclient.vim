
function! coc#source#languageclient#init() abort
  " user should set the filetypes
  return {
        \'shortcut': 'LC',
        \'filetypes': [],
        \'priority': 4,
        \}
endfunction

function! coc#source#languageclient#should_complete(opt) abort
  if empty(get(g:, 'LanguageClient_serverCommands', {}))| return 0 | endif
  return 1
endfunction

function! coc#source#languageclient#complete(opt, cb) abort
  let l:Callback = {res -> a:cb(s:FilterResult(res))}
  call LanguageClient#omniComplete({
        \ 'character': a:opt['col'],
        \ 'line': a:opt['linenr'] - 1,
        \}, l:Callback)
endfunction

function! s:FilterResult(res) abort
  let error = get(a:res, 'error', {})
  if !empty(error)
    let message = get(error, 'message', '')
    let code = get(error, 'code', '')
    call coc#util#on_error('languageclient error '. code .':'. message)
    return []
  endif
  return get(a:res, 'result', [])
endfunction
