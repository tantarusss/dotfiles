#!/usr/bin/wpexec

-- INFO
-- This script will change default audio output to the next available
-- Typically you want to use it to switch audio output between headphones and speakers.
-- Works ONLY with Wireplumber
-- In most cases you can just make the script executable and run it without any modifications.

-- SETTINGS

-- Change this to true if you have many sinks that you do not want to use
-- In that case a new sink will only be enabled if its name exists in a table below.
USE_DEVICE_NAME_FILTER = true

-- get these from `wpctl status` or `pw-dump`
SWITCHABLE_DEVICE_NAMES = {
    "alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.mono-chat",
    "alsa_output.pci-0000_2b_00.1.hdmi-stereo",
}

-- CODE

devices_om = ObjectManager {
  -- match sinks nodes
  Interest {
    type = "node",
    Constraint { "media.class", "matches", "Audio/Sink" },
  },
}
local is_device_allowed = function (name)
  if USE_DEVICE_NAME_FILTER == false then return true end
  for _, value in ipairs(SWITCHABLE_DEVICE_NAMES) do
    if value == name then return true end
  end
  return false
end

devices_om:activate()

-- Load the necessary wireplumber api modules
Core.require_api("default-nodes", function(...)
  local default_nodes  = ...

  local active_sink_id = default_nodes:call("get-default-node", "Audio/Sink")
  print("Old Sink id: " .. active_sink_id)

  for device in devices_om:iterate() do
    -- Debug.dump_table({ device.properties })
    local node_name = device.properties["node.name"]
    if device["bound-id"] ~= active_sink_id and is_device_allowed(node_name) then
      print("New Sink id: " .. device["bound-id"])
      default_nodes:call("set-default-configured-node-name", "Audio/Sink", node_name)
    end
  end
  Core.quit()
end)
