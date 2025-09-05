" Read saved breakpoint files created by GDB and insert them into the quickfix
" list automatically

function! ReadBreakpoints(filepath)
  let lines = readfile(a:filepath)
  let qflist = []
  for line in lines

    " Match file + line number form: break file.c:123
    if line =~# '^break\s\+\(\f\+\):\(\d\+\)$'
      let m = matchlist(line, '^break\s\+\(\f\+\):\(\d\+\)$')
      call add(qflist, {
            \ 'filename': m[1],
            \ 'lnum': str2nr(m[2]),
            \ 'text': 'Breakpoint, line number: ' . m[2]
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
