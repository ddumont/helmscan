addon.name = 'helmscan';
addon.author = 'Notagain';
addon.version = '1.0';
addon.desc = 'Plays sounds as a reaction to HELM nodes beaing nearby.';
addon.link = '';

require('common');
local chat = require('chat');
local settings = require('settings');

local helmscan = { cache = {} };

local entMgr = AshitaCore:GetMemoryManager():GetEntity();

settings.register('settings', 'settings_update', function(s)
  if (s ~= nil) then
    helmscan.settings = s;
  end
  settings.save();
end);

ashita.events.register('load', 'load_cb', function()
  helmscan.settings = settings.load(T{});
end);

ashita.events.register('packet_in', 'packet_in_cb', function(e)
  for i = 0, 2303 do
    local renderFlags = entMgr:GetRenderFlags0(i);

    -- is popped
    if (bit.band(renderFlags, 0x200) == 0x200) and (bit.band(renderFlags, 0x4000) == 0) then
      if (not helmscan.cache[i]) then
        local name = entMgr:GetName(i);

        if (name == 'Harvesting Point') then
          ashita.misc.play_sound(addon.path:append('harvesting.wav'));
        elseif (name == 'Excavation Point') then
          ashita.misc.play_sound(addon.path:append('excavation.wav'));
        elseif (name == 'Logging Point') then
          ashita.misc.play_sound(addon.path:append('logging.wav'));
        elseif (name == 'Mining Point') then
          ashita.misc.play_sound(addon.path:append('mining.wav'));
        end
      end
      helmscan.cache[i] = true;
    else
      helmscan.cache[i] = nil;
    end
  end
end);


return helmscan;
