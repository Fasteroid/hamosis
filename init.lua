local HAMIS_HP        = 3
local MAX_HAMIS_COUNT = 20

local function getHamisCount(enemy_hp)
    return math.min( math.max(1, math.floor(enemy_hp / HAMIS_HP + 0.5)), MAX_HAMIS_COUNT )
end

function OnWorldPreUpdate()
	local players = EntityGetWithTag("player_unit")

	for p = 1, #players, 1 do
		local ply = players[p]

		if ply then
			local x, y = EntityGetTransform(ply)
			local enemies = EntityGetInRadiusWithTag(x, y, 256, "enemy")
			for i = 1, #enemies, 1 do
				local enemy = enemies[i]
				if EntityGetName(enemy) ~= "$animal_longleg" then
					local eX, eY = EntityGetTransform(enemy)

					local damage_model = EntityGetFirstComponent(enemy, "DamageModelComponent")
    				if not damage_model then return end
    				local max_hp = ComponentGetValue2(damage_model, "max_hp")

					local hamis_count = getHamisCount(max_hp)

					for i = 1, hamis_count, 1 do
						EntityLoad("data/entities/animals/longleg.xml", eX, eY)
					end

					EntityKill(enemy)
				end
			end
		end
	end
end