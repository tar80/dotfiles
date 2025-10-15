" options
" commands
exmap next_tab obcommand workspace:next-tab
exmap prev_tab obcommand workspace:previous-tab
exmap toggle_pin obcommand workspace:toggle-pin
exmap q obcommand workspace:close
exmap qa obcommand workspace:close-window
exmap sp obcommand workspace:split-horizontal
exmap vs obcommand workspace:split-vertical
exmap focus_top obcommand editor:focus-top
exmap focus_left obcommand editor:focus-left
exmap focus_right obcommand editor:focus-right
exmap focus_bottom obcommand editor:focus-bottom
exmap link_sp obcommand editor:open-link-in-new-split
exmap comment obcommand editor:toggle-comments
exmap lineup obcommand editor:swap-line-up
exmap linedown obcommand editor:swap-line-down
exmap fold_toggle obcommand editor:toggle-fold
exmap fold_all obcommand editor:fold-all
exmap unfold_all obcommand editor:unfold-all
exmap toggle_italic obcommand editor:toggle-italics
exmap toggle_bold obcommand editor:toggle-bold
exmap toggle_st obcommand editor:toggle-strikethrough
exmap table obcommand editor:insert-table
exmap surround_wiki surround [[ ]]
exmap surround_italic_quotes surround * *
exmap surround_bold_quotes surround ** **
exmap surround_st_quotes surround ~~ ~~
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap light obcommand theme:use-light
exmap dark obcommand theme:use-dark
" keymaps
unmap <Space>
unmap ;
"nmap gc :comment<CR>
map <A-Up> :lineup<CR>
map <A-Down> :linedown<CR>
nmap <Space>h :focus_left<CR>
nmap <Space>j :focus_bottom<CR>
nmap <Space>k :focus_top<CR>
nmap <Space>l :focus_right<CR>
nmap <Space>s :sp<CR>
nmap <Space>v :vs<CR>
nmap <Space>q :q<CR>
nmap <Space>p :toggle_pin<CR>
nmap <Tab> <Nop>
nmap j gj
nmap k gk
nmap gF :link_sp<CR>
nmap gt :next_tab<CR>
nmap gT :prev_tab<CR>
nmap za :fold_toggle<CR>
nmap zM :fold_all<CR>
nmap zR :unfold_all<CR>
nmap Y y$
nmap <C-[> :nohl<CR>
nnoremap > >>
nnoremap < <<
imap <C-a> <Esc>0i
imap <C-e> <Esc>$a
imap <C-l> <Esc>lcl
imap <C-h> <BS>
imap <C-b> <Esc>i
imap <C-f> <Esc>la
imap <C-k> <Esc>lDa
imap <C-w> <Esc>vbc
nmap ;s i[[]]<Left><Left>
nmap ;i i![[]]<Left><Left>
nmap ;S i[article]({{<Space>site.baseurl<Space>}}{%<Space>post_url/<Space>%})<Esc>0<Right>
nmap ;I i![image]({{<Space>site.baseurl<Space>}}{%<Space>link<Space>/public/img/<Space>%})<Esc>0<Right>
nmap ;t :table<CR>
nmap ;i :toggle_italic<CR>
nmap ;b :toggle_bold<CR>
nmap ;u :toggle_st<CR>
vmap ;i :surround_italic_quotes<CR>
vmap ;b :surround_bold_quotes<CR>
vmap ;u :surround_st_quotes<CR>
vmap ;" :surround_double_quotes<CR>
vmap ;' :surround_single_quotes<CR>
vmap ;` :surround_backticks<CR>
vmap ;( :surround_brackets<CR>
vmap ;[ :surround_square_brackets<CR>
vmap ;{ :surround_curly_brackets<CR>
vmap ;s :surround_wiki<CR>

