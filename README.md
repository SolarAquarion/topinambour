# Topinambour

[![Gem Version](https://badge.fury.io/rb/topinambour.svg)](https://badge.fury.io/rb/topinambour)
[![Code Climate](https://codeclimate.com/github/cedlemo/topinambour/badges/gpa.svg)](https://codeclimate.com/github/cedlemo/topinambour)


<a href="https://raw.github.com/cedlemo/topinambour/master/terminal_selector_screen.gif"><img src="https://raw.github.com/cedlemo/topinambour/master/terminal_selector_screen.gif" style="width:576px;height:324px;" alt="Color selection gif"></a>

<a href="https://raw.github.com/cedlemo/topinambour/master/color_selection_screen.gif"><img src="https://raw.github.com/cedlemo/topinambour/master/color_selection_screen.gif" style="width:576px;height:324px;" alt="Color selection gif"></a>

Topinambour is Terminal written with the Gtk3 and Vte3 ruby bindings from the project [ruby-gnome2](https://github.com/ruby-gnome2/ruby-gnome2). I have written it for testing purpose, but Topinambour works well and I use it as my primary terminal emulator.

## Features

*    tabs supports
*    tabs can be reordered or selected through the preview mode ( `Shift + Ctrl + o` )
<a href="https://raw.github.com/cedlemo/topinambour/master/screenshot2.png"><img src="https://raw.github.com/cedlemo/topinambour/master/screenshot2_prev.png" width="576" height="324" alt="Screenshot"></a>

*    Each tab can be named.
*    The configuration can be done via a Css file
*    Terminal colors can be changed on the fly and saved in the CSS configuration file
<a href="https://raw.github.com/cedlemo/topinambour/master/screenshot3.png"><img src="https://raw.github.com/cedlemo/topinambour/master/screenshot3_prev.png" width="576" height="324" alt="Screenshot"></a>
*    Terminal font can be changed on the fly and saved in the CSS configuration file
<a href="https://raw.github.com/cedlemo/topinambour/master/screenshot4.png"><img src="https://raw.github.com/cedlemo/topinambour/master/screenshot4_prev.png" width="576" height="324" alt="Screenshot"></a>

*    The Css file can be edited in a tab of Topinambour and saved. Each modifications are applied while you are writting them. (Use `Shift + Ctrl + w` to close the editor)
<a href="https://raw.github.com/cedlemo/topinambour/master/screenshot5.png"><img src="https://raw.github.com/cedlemo/topinambour/master/screenshot5_prev.png" width="576" height="324" alt="Screenshot"></a>
*   Topinambour allows users to modify existing modules. For example if a user copy the css_editor.rb in the directory *~/.config/topinambour/lib/css_editor.rb*, he should be able to modify it in order to fit its needs. 

##  TODO:
*   Regex support in the terminals in order to launch web navigator if there is an url or launch a media player if there is a match for avi file for example.
*   Create more Css properties in oder to configure the terminals (cursor shape or blink mode, audible bell or not ...)
*   Make Topinambour allows users to easily create their own modules. For example create a tab that will act as a MPD client. There will be widgets that control a MPD server and a GtkTree widget that displays the playlist of the MPD server for example.

## Shortcuts

*    `Shift + Ctrl + t`  new tab
    
*    `Shift + Ctrl + q` quit Topinambour
    
*    `Shift + Ctrl + w` close current tab
    
*    `Shift + Ctrl + left` previous tab
    
*    `Shift + Ctrl + right` next tab
    
*    `Shift + Ctrl + c` display color selectors for the vte in overlay mod (Esc to leave)
     
*    `Shift + Ctrl + f` display font selector for the vte in overlay mod (Esc to leave)
    
*    `Shift + Ctrl + o` display previews of all tabs (Esc to leave)

*    `Shift + Ctrl + e` open the Css configuration editor in a new notebook tab.


## User configuration

It can be found in the file `$HOME/.config/topinambour/topinambour.css` (Be carefull by default Topinambour use fish as a default shell, if you want to use another one specify it in the topinambour.css file)

```css
*{
/* Default css properties
  -TopinambourTerminal-foreground: #aeafad;
  -TopinambourTerminal-background: #323232;
  -TopinambourTerminal-black: #000000;
  -TopinambourTerminal-red: #b9214f;
  -TopinambourTerminal-green: #A6E22E;
  -TopinambourTerminal-yellow: #ff9800;
  -TopinambourTerminal-blue: #3399ff;
  -TopinambourTerminal-magenta: #8e33ff;
  -TopinambourTerminal-cyan: #06a2dc;
  -TopinambourTerminal-white: #B0B0B0;
  -TopinambourTerminal-brightblack: #5D5D5D;
  -TopinambourTerminal-brightred: #ff5c8d;
  -TopinambourTerminal-brightgreen: #CDEE69;
  -TopinambourTerminal-brightyellow: #ffff00;
  -TopinambourTerminal-brightblue: #9CD9F0;
  -TopinambourTerminal-brightmagenta: #FBB1F9;
  -TopinambourTerminal-brightcyan: #77DFD8;
  -TopinambourTerminal-brightwhite: #F7F7F7;
  -TopinambourTerminal-font: Monospace 11;
  -TopinambourWindow-shell: "/usr/bin/fish";
  -TopinambourWindow-css-editor-style: "monokai-extended";
  -TopinambourWindow-height: 500;
  -TopinambourWindow-width: 1000;*/
}

TopinambourWindow GtkHeaderBar GtkEntry{
  border-radius: 4px;
}
TopinambourWindow GtkOverlay GtkBox#resize_box{
    background: rgba(49, 150, 188, 0.5);
    border-top: 1px;
    border-left: 1px;
    border-bottom: 1px;
    border-style: solid;
    border-color: rgba(49, 150, 188, 1);
    border-radius: 6px 0px 0px 0px;
}
TopinambourWindow GtkOverlay GtkScrolledWindow#terminal_chooser GtkBox{
    background-color: rgba(49, 150, 188, 0.5);
    border-top: 1px;
    border-left: 1px;
    border-bottom: 1px;
    border-style: solid;
    border-color: rgba(49, 150, 188, 1);
    border-radius: 6px 0px 0px 6px;
}

TopinambourWindow GtkOverlay GtkScrolledWindow GtkGrid GtkButton {
  margin: 0px;
  padding: 0px;
}

TopinambourWindow GtkOverlay GtkScrolledWindow GtkGrid GtkButton GtkImage {
  border: solid 3px rgba(0, 0, 0, 0.0);
}

.tooltip {
  background:rgba(50, 50, 50,0.5);
  border:none;
  color: #ddd;
  border-top-right-radius: 6px;
  border-bottom-left-radius: 6px;
}
```

Each time you modify this configuration via the interface of Topinambour (terminal colors selector, terminal font selector, css editor) and that you save your modifications, Topinambour create a copy of your previous Css file under a new name with :

    FileUtils.mv(USR_CSS, "#{USR_CSS}_#{Time.new.strftime('%Y-%m-%d-%H-%M-%S')}.backup")

Which means that the old file can be something like that : *topinambour.css_2016-12-5-13-20.backup*.

## Installation

### Dependancies

*   gtk3 vte3 sass

### Create the gem if needed:

    gem build topinambour.gemspec

### Install the gem :

    gem install topinambour-x.x.x.gem

### Launch the terminal

    ~> topinambour 

### Tips:

Don't forget, if you install it localy, you need that your system know the path of
the ruby gem binaries (for example).

    export PATH="${PATH}:/home/${USER}/bin:${HOME}/gem/ruby/2.3.0/bin"

#### Modifying or testing Topinambour is easy:

##### Get the sources

    git clone https://github.com/cedlemo/topinambour.git
    cd topinambour/bin
    
##### Edit the files Topinambour and test
  The filenames correspond to their functionnalities.
  Simply run `./topinambour` when you have done your modifications.

You will need fish shell if you want to test it.

### Copying:

Copyright 2015-2016 Cédric Le Moigne

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

Author : cedlemo@gmx.com
