" Originally written by scrooloose
" (http://gist.github.com/205807)

if exists("g:loaded_nerdtree_search_menuitem")
    finish
endif
let g:loaded_nerdtree_search_menuitem = 1

call NERDTreeAddMenuItem({
            \ 'text': '(g)rep directory',
            \ 'shortcut': 'g',
            \ 'callback': 'NERDTreeGrep' })

function! NERDTreeGrep()
    let dirnode = g:NERDTreeDirNode.GetSelected()

    let pattern = input("Enter the search pattern: ")
    if pattern == ''
        echo 'Aborted'
        return
    endif

    "use the previous window to jump to the first search result
    wincmd w

    "a hack for *nix to make sure the output of "search" isnt echoed in vim
    let old_shellpipe = &shellpipe
    let &shellpipe='&>'

    try
        exec 'silent cd ' . dirnode.path.str()
        exec 'silent Ack -rn ' . pattern . ' .'
        " exec 'silent ack -rn ' . pattern . ' ' . dirnode.path.str()
    finally
        let &shellpipe = old_shellpipe
    endtry

    let hits = len(getqflist())
    if hits == 0
        echo "No hits"
    elseif hits > 1
        copen
        " echo "Multiple hits. Jumping to first, use :copen to see them all."
    endif

endfunction
