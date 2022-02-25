local damageMultiplier = damageMultiplierMoves.singletarget
local effect = 1
local missileEffect = 82
local combat = COMBAT_NORMALDAMAGE
local defenseType = COMBAT_PHYSICALDAMAGE

function onCastSpell(creature, variant)
	local target = creature:getTarget()
	if not target then return true end

	local damage = damageMultiplier * creature:getTotalMeleeAttack()
	local creaturePosition = creature:getPosition()
	local targetPosition = target:getPosition()

	doSendDistanceShoot(creaturePosition, targetPosition, missileEffect)
	doTargetCombatHealth(creature.uid, target, combat, -damage, -damage, effect, defenseType)

	return true
end
