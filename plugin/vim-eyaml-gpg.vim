" vim-eyaml-gpg
" copyright 2018 Chris Allison
"
" Licensed under the GPLv3
"
" A vim plugin to easily gpg decrypt/encrypt yaml values a la eyaml

nnoremap <localleader>d :call DecryptEYaml()<cr>

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
    " did we find any encrypted blocks
    if s:foldsfound
        " are we at the start of an encrypted block
        if getline('.') =~ "ENC[GPG,"
            " is the fold open or closed
            let l:cca = foldclosed(line('.'))
            if l:cca == -1
                " fold is open, so close it
                :normal! za
            endif
            " open the fold
            " move to the 1st char past the comma
            " mark this position in mark 'z'
            " go back to the '['
            " find the matching ']' and visually select
            " everything up to and including mark 'z'
            " yank this selection into the 'z' register
            execute "normal! za0f,lmzF[%v`z\"zy"
            " open a temporary window
            :vsplit /tmp/ccajunk
            " paste the contents of the 'z' register
            execute "normal! \"zp"
            " go to the end of the block and find and delete the ']'
            execute "normal! Gf]x"
            " remove any formatting spaces (if they exist)
            :%s/ //ge
            " pass the text through base64 --decode and pipe
            " the output into gpg --decrypt
            :%!base64 -d |gpg --decrypt
            " grab the content of the last line (the decrypted value)
            execute "normal! G0\"xy$"
            " close the file without writing it
            :quit!
            " tell the user
            echom "Decrypted Value: " . @x
        else
            echom "Not at the the start of an eyaml encrypted section"
        endif
    else
        echom "no eyaml encrypted sections found."
    endif
endfunction
