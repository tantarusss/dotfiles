#!/usr/bin/wpexec

devices_om = ObjectManager {
  -- match sinks nodes
  Interest {
    type = "node",
    Constraint { "media.class", "matches", "Audio/Source" },
  },
}

devices_om:activate()

-- Load the necessary wireplumber api modules
Core.require_api("default-nodes", function(...)
  local default_nodes  = ...

  local active_sink_id = default_nodes:call("get-default-node", "Audio/Source")

  for device in devices_om:iterate() do
    local node_description = device.properties["node.description"]
    if device["bound-id"] == active_sink_id then
      print(node_description)
    end
  end
  Core.quit()
end)
