addon.name      = 'trustcheck';
addon.author    = 'Lumaro';
addon.version   = '1.0';
addon.desc      = 'Automatically create a user page template trust checklist for bg-wiki.com';
addon.link      = 'https://github.com/Lumariano/trustcheck';

require('common');
local chat = require('chat');

local ignored_spell_ids = T{
    953,    -- Pieuje (UC)
    954,    -- I. Shield (UC)
    955,    -- Apururu (UC)
    956,    -- Jakoh (UC)
    957,    -- Flaviria (UC)
    980,    -- Yoran-Oran (UC)
    981,    -- Sylvie (UC)
    1002,   -- Cornelia
    1003,   -- Matsui-P
    1005,   -- Ayame (UC)
    1006,   -- Maat (UC)
    1007,   -- Aldo (UC)
    1008,   -- Naja (UC)
};

ashita.events.register('command', 'command_cb', function (e)
    if (e.command ~= '/trustcheck') then
        return;
    end

    e.blocked = true;

    local file = ('%s\\addons\\' .. addon.name .. '\\trusts.txt'):fmt(AshitaCore:GetInstallPath());
    local f = io.open(file, 'w+');
    if(f == nil) then
        print(chat.header(addon.name):append(chat.error('Could not write to file ' .. file)));
        return;
    end

    f:write('{{Trust Checklist\n');
    f:write('|Complete-Color = green\n');
    f:write('|Default-Color = black\n');

    for i = 896, 1019 do
        if (not ignored_spell_ids:contains(i)) then
            local spell = AshitaCore:GetResourceManager():GetSpellById(i);
            if (spell.Name[1] ~= '') then
                f:write(string.format('| %s = ', spell.Name[1]));
                if (AshitaCore:GetMemoryManager():GetPlayer():HasSpell(i)) then
                    f:write('Complete');
                end
                f:write('\n');
            end
        end
    end

    f:write('}}');
    f:close();
    print(chat.header(addon.name):append(chat.success('Wrote Trusts to ' .. file)));
end)