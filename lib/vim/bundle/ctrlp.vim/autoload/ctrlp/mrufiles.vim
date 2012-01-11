" =============================================================================
" File:          autoload/ctrlp/mrufiles.vim
" Description:   Most Recently Used Files extension
" Author:        Kien Nguyen <github.com/kien>
" =============================================================================

" Static variables {{{1
fu! ctrlp#mrufiles#opts()
	let opts = {
		\ 'g:ctrlp_mruf_max': ['s:max', 250],
		\ 'g:ctrlp_mruf_include': ['s:include', ''],
		\ 'g:ctrlp_mruf_exclude': ['s:exclude', ''],
		\ 'g:ctrlp_mruf_case_sensitive': ['s:csen', 1],
		\ }
	for [ke, va] in items(opts)
		exe 'let' va[0] '=' string(exists(ke) ? eval(ke) : va[1])
	endfo
	let s:csen = s:csen ? '#' : '?'
	let s:cadir = ctrlp#utils#cachedir().ctrlp#utils#lash().'mru'
	let s:cafile = s:cadir.ctrlp#utils#lash().'cache.txt'
endf
cal ctrlp#mrufiles#opts()
fu! ctrlp#mrufiles#list(bufnr, ...) "{{{1
	if s:locked | retu | en
	" Get the list
	let mrufs = ctrlp#utils#readfile(s:cafile)
	" Remove non-existent files
	if a:0 && a:1 == 1
		let mrufs = s:rmdeleted(mrufs)
	elsei a:0 && a:1 == 2
		cal ctrlp#utils#writecache([], s:cadir, s:cafile)
		retu []
	en
	" Return the list, filter the active buffer
	if a:bufnr == -1
		let crfile = fnamemodify(bufname(winbufnr(winnr('#'))), ':p')
		retu empty(crfile) ? mrufs : filter(mrufs, 'v:val !='.s:csen.' crfile')
	en
	" Filter it
	let filename = fnamemodify(bufname(a:bufnr + 0), ':p')
	if empty(filename) || !empty(&bt)
		\ || ( !empty(s:include) && filename !~# s:include )
		\ || ( !empty(s:exclude) && filename =~# s:exclude )
		\ || ( index(mrufs, filename) < 0 && !filereadable(filename) )
		retu
	en
	" Remove old matched entry
	cal filter(mrufs, 'v:val !='.s:csen.' filename')
	" Insert new one
	cal insert(mrufs, filename)
	" Remove oldest entry
	if len(mrufs) > s:max | cal remove(mrufs, s:max, -1) | en
	cal ctrlp#utils#writecache(mrufs, s:cadir, s:cafile)
endf "}}}
fu! s:rmdeleted(mrufs) "{{{
	cal filter(a:mrufs, '!empty(ctrlp#utils#glob(v:val, 1))')
	cal ctrlp#utils#writecache(a:mrufs, s:cadir, s:cafile)
	retu a:mrufs
endf
fu! ctrlp#mrufiles#init() "{{{1
	let s:locked = 0
	aug CtrlPMRUF
		au!
		au BufReadPost,BufNewFile,BufWritePost *
			\ cal ctrlp#mrufiles#list(expand('<abuf>', 1))
		au QuickFixCmdPre  *vimgrep* let s:locked = 1
		au QuickFixCmdPost *vimgrep* let s:locked = 0
	aug END
endf
"}}}

" vim:fen:fdm=marker:fmr={{{,}}}:fdl=0:fdc=1:ts=2:sw=2:sts=2
