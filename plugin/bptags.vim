" Read saved breakpoint files created by GDB and insert them into the quickfix
" list automatically
function! ReadBreakpoints(filepath)
  let lines = readfile(a:filepath)
  let qflist = []
  for line in lines

    " Match file + line number form: break file.c:123
    if line =~# '^break\s\+\(\f\+\):\(\d\+\)$'
      let m = matchlist(line, '^break\s\+\(\f\+\):\(\d\+\)$')
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
    elseif line =~# '^break\s\+\(\k\+\)$'
      let m = matchlist(line, '^break\s\+\(\k\+\)$')
      let tags = taglist(m[1])
      if len(tags) > 0
        " TODO: There may be a smarter way rather than simply reading
        " every single match. Could cause problems.
        for t in tags
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

command! -nargs=1 -complete=file ReadBreakpoints call ReadBreakpoints(<f-args>)
command! Mktags !ctags --fields=+n  -R .
