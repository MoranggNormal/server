local time = 5 -- tempo entre os projéteis
local waves = 5 -- quantidade de projéteis lançados
local delay = 50 -- é o tempo entre subir e descer dos projéteis
local damageMultiplier = damageMultiplierMoves.areawaves/waves
local projectileEffectUp = 93
local projectileEffectDown = 93
local areaEffect = 492
local areaSize = 6
local area = createCombatArea(AREA_CIRCLE6X6)

local function sendDown(uid, toposup, toposdown)
	local creature = Creature(uid)
	if creature then
		doSendDistanceShoot(toposup, toposdown, projectileEffectDown)
	end
end

local function dealDamage(uid, position, damage, toposdown)
	local creature = Creature(uid)
	if creature then
		doSendMagicEffect(toposdown, areaEffect)
		doAreaCombatHealth(uid, COMBAT_ELECTRICDAMAGE, position, area, -damage, -damage, 0)
	end
end

local function spellCallback(uid, damage, count)
	local creature = Creature(uid)
	if creature then
		local position = creature:getPosition()
		local toposup = creature:getPosition()
		local toposdown = creature:getPosition()
		toposup.x = toposup.x + math.random(-4,4)
		toposup.y = toposup.y + math.random(-15,-5)
		toposdown.x = toposdown.x + math.random(-areaSize,areaSize)
		toposdown.y = toposdown.y + math.random(-areaSize,areaSize)
		if count <= waves then
			local d = getDistanceBetween(toposup, toposdown)
			local dt = delay + d * 37
			
			local tile = Tile(toposdown)
			if tile and not (tile:getHouse() or tile:hasFlag(TILESTATE_PROTECTIONZONE) or tile:hasFlag(TILESTATE_FLOORCHANGE) or tile:hasFlag(TILESTATE_BLOCKSOLID)) then
				doSendDistanceShoot(position, toposup, projectileEffectUp)
				addEvent(sendDown, delay, uid, toposup, toposdown)
				addEvent(dealDamage, dt, uid, position, damage, toposdown)
			end
			count = count + 1			
			addEvent(spellCallback, time, uid, damage, count)
		end
	end
end

function onCastSpell(creature, variant)

	local damage = damageMultiplier * creature:getTotalMagicAttack()

	spellCallback(creature.uid, damage, 1)
	return true
end
