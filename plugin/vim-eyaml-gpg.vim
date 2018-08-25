" vim-eyaml-gpg
" copyright 2018 Chris Allison
"
" Licensed under the GPLv3
"
" A vim plugin to easily gpg decrypt/encrypt yaml values a la eyaml

nnoremap <localleader>j :call DecryptEYaml()<cr>

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

function DecryptEYaml()
    if s:foldsfound
        if getline('.') =~ "ENC[GPG,"
            let cca = foldclosed(line('.'))
            if cca == -1
                :normal! za
            endif
            execute "normal! za0f,lmzF[%v`z\"zy"
            :vsplit /tmp/ccajunk
            execute "normal! \"zp"
            execute "normal! Gf]x"
            :%s/ //ge
            :%!base64 -d |gpg --decrypt
            execute "normal! G0\"xy$"
            :quit!
            echom "Decrypted Value: " . @x
        else
            echom "Not at the the start of an eyaml encrypted section"
        endif
    else
        echom "no eyaml encrypted sections found."
    endif
endfunction
