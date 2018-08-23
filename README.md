# vim-eyaml-gpg
Plugin to fold gpg encrypted blocks managed by eyaml.

## install
use [pathogen](https://github.com/tpope/vim-pathogen) to manage your plugins.

`git clone` this repo into `$HOME/.vim/bundle/

restart vim

## Usage
when opening a yaml format file that has encrypted blocks managed by eyaml this
plugin attempts to detect them and creates manual folds of them.  You can open
the fold by putting the cursor on the fold and typing `za`.  The same key
sequence will close the fold again.
