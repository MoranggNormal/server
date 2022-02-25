local time = 200

local area = {}
table.insert(area, createCombatArea(LeafStorm1))
table.insert(area, createCombatArea(LeafStorm2))
table.insert(area, createCombatArea(LeafStorm3))
table.insert(area, createCombatArea(LeafStorm4))
table.insert(area, createCombatArea(LeafStorm2))
table.insert(area, createCombatArea(LeafStorm1))
table.insert(area, createCombatArea(LeafStorm3))

local areaDamage = {}
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))

local effect = {}
table.insert(effect, 199)
table.insert(effect, 488)
table.insert(effect, 199)
table.insert(effect, 199)
table.insert(effect, 199)
table.insert(effect, 488)
table.insert(effect, 199)

local damageMultiplier = damageMultiplierMoves.areawaves/#area

local function spellCallback(uid, position, damage, count)
	local creature = Creature(uid)
	if creature then		
		if count <= #area then
			if not effect[count] or not areaDamage[count] then return true end
			doAreaCombatHealth(uid, COMBAT_GRASSDAMAGE, position, area[count], 0, 0, effect[count])
			doAreaCombatHealth(uid, COMBAT_GRASSDAMAGE, position, areaDamage[count], -damage, -damage, 0)
			count = count + 1			
			addEvent(spellCallback, time, uid, position, damage, count)
		end
	end
end

function onCastSpell(creature, variant)

	local damage = damageMultiplier * creature:getTotalMagicAttack()
	local position = creature:getPosition()

	spellCallback(creature.uid, position, damage, 1)
	return true
end
