-- the various toxic clouds contribute 2 sources of damage:
--  - direct damage from the SmokeWithTrigger prototype, which applies once every 30 ticks
--  - apply a sticker onto the target which continues ticking even if the target leaves the area
for _, prototype in pairs(data.raw["smoke-with-trigger"]) do
    if string.find(prototype.name, "%-cloud%-rampant%-arsenal") and string.find(prototype.name, "toxic") then
        -- big-toxic-cloud-rampant-arsenal does not have an attached action for whatever reason
        if prototype.action ~= nil then
            -- reduce direct damage to 10% (around 3.5x better than poison capsules)
            -- as of 2024-04-23 this is at position 1 in the table
            local target_effects = prototype.action.action_delivery.target_effects.action.action_delivery.target_effects
            target_effects[1].damage.amount = target_effects[1].damage.amount / 20
            -- show the damage from sticker in the tooltip as well
            target_effects[2].show_in_tooltip = true
        end
    end
end

-- stickers are also directly applied by bio ammo, not just toxic clouds
for _, prototype in pairs(data.raw["sticker"]) do
    if string.find(prototype.name, "%-sticker%-rampant%-arsenal") and string.find(prototype.name, "toxic") then
        -- reduce damage done by the sticker to 5%
        prototype.damage_per_tick.amount = prototype.damage_per_tick.amount / 20
        -- but increase the effect duration by 800%, bringing the total damage output to 60% of original
        prototype.duration_in_ticks = prototype.duration_in_ticks * 8
        -- also double the intensity of the movement modifier and add a flat 0.25 on top
        prototype.target_movement_modifier = 1 - ((1 - prototype.target_movement_modifier) * 2 + 0.25)
        -- this should let bio damage specialise as a crowd-control and damage-over-time option
    end
end
