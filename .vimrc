" =========================
" 基础行为
" =========================
set nocompatible
set hidden
set mouse=a
set clipboard=unnamedplus

" =========================
" 行号
" =========================
set number
set relativenumber

augroup numbertoggle
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END

" =========================
" 缩进（对代码非常重要）
" =========================
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" =========================
" 搜索体验
" =========================
set ignorecase
set smartcase
set incsearch
set hlsearch

" =========================
" 显示与交互
" =========================
set cursorline
set scrolloff=5
set signcolumn=yes

" =========================
" 文件与编码
" =========================
set encoding=utf-8
set fileencoding=utf-8

