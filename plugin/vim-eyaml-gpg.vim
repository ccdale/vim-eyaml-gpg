" vim-eyaml-gpg
" copyright 2018 Chris Allison
"
" Licensed under the GPLv3
"
" A vim plugin to easily gpg decrypt/encrypt yaml values a la eyaml

" nnoremap <localleader>j :call DecryptYaml()<cr>

augroup eyamlgpg
    autocmd!
    autocmd FileType yaml call s:FoldEYaml()
augroup END

function s:FoldEYaml()
    setlocal foldmethod=manual
    let s:foldsfound = 0
    let s:location = 1
    while s:location
        let s:location = search("ENC\[GPG,","cW")
        execute "normal! f[zf%j"
        if s:location
            let s:foldsfound += 1
        endif
    endwhile
endfunction

" function DecryptYaml()
"     if s:foldsfound
"         echom "decrypting"
"         execute "normal! za0f,lmzF[%v`z\"wy"
"     else
"         echom "no encrypted stuff found"
"     endif
" endfunction
