" vim-eyaml-gpg
" copyright 2018 Chris Allison
"
" Licensed under the GPLv3
"
" A vim plugin to fold eyaml encrypted sections
" allows viewing of the decrypted value if required

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
            " store the z and x register contents
            let l:ccaz = @z
            let l:ccax = @x
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
            " close the fold
            silent! execute "normal! za0f,lmzF[%v`z\"zyza"
            " open a temporary window
            :vnew
            " ensure nothing is written to disk
            setlocal bufhidden=hide
            setlocal nobuflisted
            setlocal buftype=nofile
            setlocal nofoldenable
            setlocal nonumber
            setlocal noswapfile
            " paste the contents of the 'z' register
            silent! execute "normal! \"zp"
            " go to the end of the block and find and delete the ']'
            silent! execute "normal! Gf]x"
            " remove any formatting spaces (if they exist)
            :silent! %s/ //ge
            " pass the text through base64 --decode and pipe
            " the output into gpg --decrypt
            :silent! %!base64 -d |gpg --decrypt
            " grab the content of the last line (the decrypted value)
            execute "normal! G0\"xy$"
            " close the window without writing to disk
            :quit!
            " tell the user
            echom "Decrypted Value: " . @x
            " restore the z and x registers
            let @x = l:ccax
            let @z = l:ccaz
        else
            echom "Not at the the start of an eyaml encrypted section"
        endif
    else
        echom "no eyaml encrypted sections found."
    endif
endfunction
