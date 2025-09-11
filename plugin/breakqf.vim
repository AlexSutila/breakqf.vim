" Read saved breakpoint files created by GDB and insert them into the quickfix
" list automatically
function! ReadBreakpoints(filepath)
  let lines = readfile(a:filepath)
  let qflist = []
  for line in lines

    " Match file + line number form: break file.c:123
    if line =~# '^break\s\+\(.\{-}\):\(\d\+\)$'
      let m = matchlist(line, '^break\s\+\(.\{-}\):\(\d\+\)$')
      let file = m[1]
      let lnum = str2nr(m[2])

      " Do relative path resolving in case the full relpath is not
      " provided in the information given in the breakpoints file
      if !filereadable(file)
        let found = findfile(fnamemodify(file, ':t'), '**')
        if !empty(found)
          let file = found
        endif
      endif
      call add(qflist, {
            \ 'filename': file,
            \ 'lnum': lnum,
            \ 'text': 'Breakpoint, line number: ' . lnum
            \ })

    " Match function name form: break funcname
    elseif line =~# '^break\s\+\(\k\+\%(::\k\+\)*\)'
      let m = matchlist(line, '^break\s\+\(\k\+\%(::\k\+\)*\)')
      let funcname = matchstr(m[1], '\k\+$')
      let tags = taglist(funcname)
      if len(tags) > 0
        for t in tags

          " Neovim devs decided to do what ever this encoding is so if the
          " line number doesn't exist, we add it ourselves. Idk why they did
          " this but it makes me irrationally angry lol.
          if !has_key(t, 'line')
            let matchnum = matchstr(t['cmd'], '%\zs\d\+\ze[l]')
            let t['line'] = matchnum
          endif

          call add(qflist, {
                \ 'filename': t['filename'],
                \ 'lnum': t['line'],
                \ 'text': 'Breakpoint, function: ' . m[1]
                \ })
        endfor
      endif
    endif

  endfor
  call setqflist(qflist, 'r')
endfunction

command! -nargs=1 -complete=file WriteBreakpoint call writefile(['break ' . expand('%:t') . ':' . line('.')], <f-args>, 'a')
command! -nargs=1 -complete=file ReadBreakpoints call ReadBreakpoints(<f-args>)
command! Mktags !ctags --fields=+n  -R .
