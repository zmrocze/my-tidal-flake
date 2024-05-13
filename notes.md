
## Okey

So the content of main.tidal is sent on shift+enter (how to send multiline? ctrl+enter) to ghci.
Ghci is initialized with BootTidal.hs (not part of this repo but defined somewhere in the mitch's flake).

## link

https://github.com/mitchmindtree/tidalcycles.nix

## devshell

superdirt-start
tidal
superdirt-install
vim-tidal

## todo

 - custom BootTidal.hs (check `cat $(which tidal)`, write simmilar wrapper, make tidalcycles.nix provide `ghci`, best if also full haskell dev environment). Can define our common functions then 