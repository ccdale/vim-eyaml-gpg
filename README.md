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

## Decrypting
You can decrypt the encrypted block with `<localleader>d` (localleader is '\\'
on my system). The decrypted value is placed onto the message tree and should
appear on the vim command line. Should it have scrolled off, or not show
you the 'Press Enter to continue' message, you can view it with `:messages`.

The decryption uses a tempory buffer, completely in memory, so nothing is
written to disk.  It is destroyed immediately after decrypting. The registers
used to pass encrypted and decrypted strings around are reset to the values
they had before decryption started, so there is no chance of the data being
written out to any .viminfo files.
