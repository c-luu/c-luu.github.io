---
layout: post
title:  "Managing Vim configs with GitHub"
date:   2016-04-28 23:17:12 +0000
categories: [Dev]
tags: [git, vim]
---

If you're new to Vim and interested in customizing your Vim configurations to use across multiple boxes, this post may help you. 

### Vim the text editor
Vim is a lightweight, [ubiquitous][vim-download] text editor for code and text editing. It's pre-installed on the majority of *nix boxes and has bindings and commands to edit text efficiently. Using Vim proves useful when I'm working in multiple boxes throughout the day, i.e., connecting to servers to debug an issue or writing Python code in a virtual machine for school assignments.

### Working with configuration files (vimrc)
Vim has a configuration file where you can have your custom plug-ins and settings defined. Since I'm relatively new to Vim and don't use plug-ins, my configuration is simple:

{% highlight Vimscript %}
filetype plugin indent on
syntax on

set relativenumber number
set clipboard=unnamed

" Colors
colorscheme elflord
{% endhighlight %}

Here, I have some convenient settings like setting [relative numbers][relative-numbers] and an alternate color-scheme.

### Syncing
Having my custom Vim settings on hand is helpful to avoid having to manually set configurations on each environment, so I pushed my settings to GitHub under a project called 'dotfiles'. Using [sym-links] and GitHub, we can now download our settings to any box with an internet connection.

To sync, create a directory named 'vim' and move your vimrc file into this directory. Push this directory up to your GitHub account under whatever project name you decide. When you're ready to sync your settings, log into your box and follow the subsequent instructions based on what operating system you're running:

#### *nix Setup

1. Clone into ~/yourRepoDirectory/...
2. Remove ~/.vim directory and ~/.vimrc 
3. ln -s ~/yourRepoDirectory/dotfiles/vim ~/.vim 

#### Windows Setup
1. Clone into ~/yourRepoDirectory/...
2. Remove ~/vimfiles directory and ~/\_vimfiles 
3. ln -s ~/yourRepoDirectory/dotfiles/vim ~/vimfiles
	1. If permission issues: [read here.](http://www.dotnetsurfers.com/blog/2013/10/15/using-the-same-vimrc-with-multiple-operating-systems)

[vim-download]: https://vim.sourceforge.io/download.php
[relative-numbers]: https://vi.stackexchange.com/questions/3/how-can-i-show-relative-numbers
[sym-links]: https://teamtreehouse.com/community/creating-a-symbolic-link-in-windows

