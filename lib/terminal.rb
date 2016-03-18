# Copyright 2015-2016 Cédric LE MOIGNE, cedlemo@gmx.com
# This file is part of Topinambour.
#
# Topinambour is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Topinambour is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Topinambour.  If not, see <http://www.gnu.org/licenses/>.

TERMINAL_COLOR_NAMES = [:foreground, :background, :black, :red, :green, :yellow, :blue, :magenta, :cyan, :white,
                        :brightblack, :brightred, :brightgreen, :brightyellow, :brightblue, :brightmagenta, :brightcyan, :brightwhite]
DEFAULT_TERMINAL_COLORS = %w(#aeafad #323232 #000000 #b9214f #A6E22E #ff9800 #3399ff #8e33ff #06a2dc
                             #B0B0B0 #5D5D5D #ff5c8d #CDEE69 #ffff00 #9CD9F0 #FBB1F9 #77DFD8 #F7F7F7)
DEFAULT_TERMINAL_FONT = "Monospace 11"
##
# The default vte terminal customized
class TopinambourTerminal < Vte::Terminal
  extend TopinambourStyleProperties
  attr_reader :pid, :menu
  attr_accessor :preview, :colors, :tab_label
  type_register
  TERMINAL_COLOR_NAMES.each_with_index do |c|
    name = c.to_s
    self.install_style("boxed",
                        name,
                        GLib::Type["GdkRGBA"])
  end
  self.install_style("boxed",
                     "font",
                     GLib::Type["PangoFontDescription"])

  ##
  # Create a new TopinambourTerminal instance that runs command_string
  def initialize(command_string, working_dir = nil)
    super()
    # TODO: make a begin/rescue like in glib2-2.2.4/sample/shell.rb
    command_array = GLib::Shell.parse(command_string)
    @pid = spawn(:argv => command_array,
                 :working_directory => working_dir,
                 :spawn_flags => GLib::Spawn::SEARCH_PATH)

    signal_connect "child-exited" do |widget|
      notebook = widget.parent
      current_page = notebook.page_num(widget)
      notebook.remove_page(current_page)
      notebook.toplevel.application.quit unless notebook.n_pages >= 1
    end

    signal_connect "window-title-changed" do |widget|
      if parent && parent.current == self
        current_label = parent.get_tab_label(widget)
        if @tab_label.class == String
          current_label.text = @tab_label
        else
          current_label.text = window_title
          parent.toplevel.current_label.text = window_title
        end
      end
    end

    builder = Gtk::Builder.new(:resource => "/com/github/cedlemo/topinambour/terminal-menu.ui")
    @menu = Gtk::Popover.new(self, builder["termmenu"])
    
    signal_connect "button-press-event" do |widget, event|
      if event.type == Gdk::EventType::BUTTON_PRESS &&
         event.button == Gdk::BUTTON_SECONDARY
        display_copy_past_menu(widget, event)
        true
      elsif event.button == Gdk::BUTTON_PRIMARY
        manage_regex_on_click(widget, event)
        true
      else
        false
      end
    end

    configure
  end

  def pid_dir
    File.readlink("/proc/#{@pid}/cwd")
  end

  def css_colors
    colors = []
    background = parse_css_color(TERMINAL_COLOR_NAMES[0].to_s)
    foreground = parse_css_color(TERMINAL_COLOR_NAMES[1].to_s)
    TERMINAL_COLOR_NAMES[2..-1].each do |c|
      colors << parse_css_color(c.to_s)
    end
    [background, foreground] + colors
  end

  def css_font
    font = style_get_property("font")
    unless font
      font = Pango::FontDescription.new(DEFAULT_TERMINAL_FONT)
    end
    font
  end

  def apply_colors
    set_colors(@colors[0], @colors[1], @colors[2..-1])
  end

  private

  def parse_css_color(color_name)
    default_color = Gdk::RGBA.parse(DEFAULT_TERMINAL_COLORS[TERMINAL_COLOR_NAMES.index(color_name.to_sym)])
    color_from_css = style_get_property(color_name)
    color = color_from_css ? color_from_css : default_color
    color
  end

  def configure
    set_rewrap_on_resize(true)
    set_scrollback_lines(-1)
    @colors = css_colors
    set_font(css_font)
    apply_colors
    add_matches
  end

  def add_matches
    @REGEXES = [:REGEX_URL_AS_IS, :REGEX_URL_FILE, :REGEX_URL_HTTP,
                :REGEX_URL_VOIP, :REGEX_EMAIL, :REGEX_NEWS_MAN]
    @REGEXES.each do |name|
      regex_name = TopinambourRegex.const_get(name)
      flags = [GLib::RegexCompileFlags::OPTIMIZE, 
               GLib::RegexCompileFlags::MULTILINE]
      regex = GLib::Regex.new(regex_name, :compile_options => flags)
      match_add_gregex(regex, 0)
    end
  end
  
  def display_copy_past_menu(widget, event)
    x, y = event.window.coords_to_parent(event.x,
                                         event.y)
    rect = Gdk::Rectangle.new(x - allocation.x,
                              y - allocation.y,
                              1,
                              1)
    widget.menu.set_pointing_to(rect)
    widget.menu.show
  end
  
  def manage_regex_on_click(widget, event)
    puts match_check_event(event).inspect
  end
end
