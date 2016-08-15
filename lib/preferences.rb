# Copyright 2016 Cedric LE MOIGNE, cedlemo@gmx.com
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
require "gtksourceview3"

module TopinambourPreferences
  def self.generate_dialog(parent)
    resource_file = "/com/github/cedlemo/topinambour/prefs-dialog.ui"
    builder = Gtk::Builder.new(:resource => resource_file)
    dialog = builder["Preferences_dialog"]
    dialog.transient_for = parent
    add_actions(builder, parent)
    connect_response(dialog, builder)
    dialog
  end

  def self.connect_response(dialog, builder)
    dialog.signal_connect "response" do |widget, response|
      case response
      when 1
        on_apply_response(widget, builder)
      else
        widget.destroy
      end
    end
  end

  def self.on_apply_response(widget, builder)
    props = get_all_properties(widget, builder)
    toplevel = widget.transient_for
    toplevel.application.update_css(props)
    widget.destroy
  end

  def self.get_all_properties(widget, builder)
    props = {}
    props.merge!(get_entry_value(builder))
    props.merge!(get_switch_values(builder))
    props.merge!(get_spin_values(widget))
    props.merge!(get_combo_values(builder))
  end

  def self.add_actions(builder, parent)
    %w(audible_bell allow_bold scroll_on_output
       scroll_on_keystroke rewrap_on_resize mouse_autohide).each do |prop_name|
      gen_switch_actions(prop_name, builder, parent)
    end
    gen_entry_actions("shell", builder, parent)
    %w(cursor_shape cursor_blink_mode backspace_binding
       delete_binding).each do |prop_name|
      gen_combobox_actions(prop_name, builder, parent)
    end
    gen_spinbuttons_actions(builder, parent)
  end

  def self.gen_switch_actions(property_name, builder, parent)
    switch = builder["#{property_name}_switch"]
    switch.active = parent.notebook.current.send("#{property_name}?")
    switch.signal_connect "state-set" do |_widget, state|
      parent.notebook.send_to_all_terminals("#{property_name}=", state)
      false
    end
  end

  def self.gen_entry_actions(property_name, builder, parent)
    entry = builder["#{property_name}_entry"]
    entry.text = parent.shell
    entry.set_icon_from_icon_name(:secondary, "edit-clear")
    entry.signal_connect("activate") { |widget| parent.shell = widget.text }

    entry.signal_connect "icon-release" do |widget, position|
      if position == :secondary
        parent.shell = widget.text = parent.style_get_property(property_name)
      end
    end
  end

  def self.gen_combobox_actions(property_name, builder, parent)
    combobox = builder["#{property_name}_sel"]
    id = parent.notebook.current.send("#{property_name}").nick + "_id"
    combobox.active_id = id
    combobox.signal_connect "changed" do |widget|
      value = widget.active_id.gsub(/_id/, "").to_sym
      parent.notebook.send_to_all_terminals("#{property_name}=", value)
    end
  end

  def self.gen_spinbuttons_actions(builder, parent)
    width_spin = builder["width_spin"]
    height_spin = builder["height_spin"]
    width_spin.set_range(0, 2000)
    height_spin.set_range(0, 1000)
    width_spin.value, height_spin.value = parent.size
    gen_width_button_action(width_spin, parent)
    gen_height_button_action(height_spin, parent)
  end

  def self.gen_width_button_action(spin_widget, parent)
    spin_widget.signal_connect "value-changed" do |widget|
      _, h = parent.size
      parent.resize(widget.value, h)
      w, _h = parent.size
      widget.value = w if widget.value + 1 < w
    end
  end

  def self.gen_height_button_action(spin_widget, parent)
    spin_widget.signal_connect "value-changed" do |widget|
      w, _h = parent.size
      parent.resize(w, widget.value)
      _, h = parent.size
      widget.value = h if widget.value + 1 < h
    end
  end

  def self.get_entry_value(builder)
    text = builder["shell_entry"].text
    { "-TopinambourWindow-shell" => text }
  end

  def self.get_switch_values(builder)
    props = {}
    %w(audible_bell allow_bold scroll_on_output
       scroll_on_keystroke rewrap_on_resize mouse_autohide).each do |prop_name|
      switch = builder["#{prop_name}_switch"]
      name = prop_name.tr("_", "-")
      props["-TopinambourTerminal-#{name}"] = switch.active?
    end
    props
  end

  def self.get_combo_values(builder)
    props = {}
    %w(cursor_shape cursor_blink_mode backspace_binding
       delete_binding).each do |prop_name|
      combobox = builder["#{prop_name}_sel"]
      value = combobox.active_id.gsub(/_id\z/, "")
      name = prop_name.tr("_", "-")
      props["-TopinambourTerminal-#{name}"] = value.to_sym
    end
    props
  end

  def self.get_spin_values(widget)
    props = {}
    w, h = widget.transient_for.size
    props["-TopinambourWindow-width"] = w
    props["-TopinambourWindow-height"] = h
    props
  end
end
