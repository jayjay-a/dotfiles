#!/bin/zsh

# gets whatever directory this script is
DOTFILEDIR=$0:A:h
# date yyyymmdd format
DATE=$(date +%Y%m%d)

echo "running..."
# gets only the dotfiles in the repo directory. look up zsh globbing for more info on syntax
for file in $DOTFILEDIR/**/.*(.); 
  # check if file exist
  do echo "----------------------------------------------------------------"
  # :t gets just filename
  if [[ -f ~/$file:t ]]; then
    # compare checksum
    # if shasum of local dotfile is not equal to repo dotfile
    if [[ $(shasum ~/$file:t | awk '{ print $1 }') != $(shasum $DOTFILEDIR/$file:t | awk '{ print $1 }') ]]; then
      # backup and replace
      echo "backing up local $file:t to ~/$file:t.bak.$DATE"
      # copy current local dotfile to local dotfile.bak.yyyymmdd
      cp ~/$file:t ~/$file:t.bak.$(date +%Y%m%d)
      echo "replacing local $file:t with repo's dotfile"
      # copy repo dotfile to local dotfile
      cp $DOTFILEDIR/$file:t ~/$file:t
    else
      # do nothing when local dotfile matches with repo dotfile
      echo "local $file:t matches with repo"
    fi
  else 
    echo "~/$file:t does not exist. creating it now"
    # copy repo dotfile to local dotfile
    cp $DOTFILEDIR/$file:t ~/$file:t
  fi;
done

echo "----------------------------------------------------------------"
echo "done :-)!"
