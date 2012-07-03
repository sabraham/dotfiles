#!/bin/bash
#
# adapted from
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/


dir=~/dotfiles
dir_old=~/dotfiles_old
files="bashrc emacs"

mkdir -p $dir_old
cd $dir
for file in $files; do
    mv ~/.$file $dir_old
    ln -s $dir/$file ~/.$file
done

rm ~/.bash_profile
ln -s $dir/bash_profile ~/.bash_profile
