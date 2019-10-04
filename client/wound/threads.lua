Citizen.CreateThread(function()
<<<<<<< Updated upstream
    if Config.Debug then
        while true do
            local limbs = ''
            for k, v in pairs(injured) do
                if limbs ~= '' then
                    limbs = limbs .. '~s~, ~r~' .. v.part .. '~s~[~r~' .. v.severity .. '~s~]'
                else
                    limbs = v.part .. '~s~[~r~' .. v.severity .. '~s~]'
                end
            end

            DrawUIText(4, 0, 0.015, 0.78, 0.35, 255, 255, 255, 255, 'Hospitalized: ~r~' .. tostring(isInHospitalBed))
            DrawUIText(4, 0, 0.015, 0.76, 0.35, 255, 255, 255, 255, 'Injured: ~r~' .. limbs)
            DrawUIText(4, 0, 0.015, 0.72, 0.35, 255, 255, 255, 255, 'Next Damage: ~r~' .. tonumber(isBleeding) * Config.BleedTickDamage)
            DrawUIText(4, 0, 0.015, 0.74, 0.35, 255, 255, 255, 255, 'Bleed: ~r~' .. bleedTickTimer .. '~s~ / ~r~' .. Config.BleedTickRate .. '~s~ | ~r~' .. isBleeding)
            DrawUIText(4, 0, 0.015, 0.7, 0.35, 255, 255, 255, 255, 'Adv. Bleed: ~r~' .. advanceBleedTimer .. '~s~ / ~r~' .. Config.AdvanceBleedTimer)
            DrawUIText(4, 0, 0.015, 0.68, 0.35, 255, 255, 255, 255, 'Fadeout: ~r~' .. fadeOutTimer .. '~s~ / ~r~' .. Config.FadeOutTimer)
            DrawUIText(4, 0, 0.015, 0.66, 0.35, 255, 255, 255, 255, 'Blackout: ~r~' .. blackoutTimer .. '~s~ / ~r~' .. Config.BlackoutTimer)
            DrawUIText(4, 0, 0.015, 0.64, 0.35, 255, 255, 255, 255, 'Adrenaline: ~r~' .. onDrugs .. ' ~s~| ~r~' .. tostring(wasOnDrugs))
            DrawUIText(4, 0, 0.015, 0.62, 0.35, 255, 255, 255, 255, 'Painkiller: ~r~' .. onPainKiller .. ' ~s~| ~r~' .. tostring(wasOnPainKillers))
            DrawUIText(4, 0, 0.015, 0.6, 0.35, 255, 255, 255, 255, 'Limping: ~r~' .. tostring(IsInjuryCausingLimp() and not (onPainKiller > 0)))
            Citizen.Wait(1)
        end
    end
end)

Citizen.CreateThread(function()
=======
>>>>>>> Stashed changes
	while true do
		if #injured > 0 then
			local level = 0
			for k, v in pairs(injured) do
				if v.severity > level then
					level = v.severity
				end
			end

			SetPedMoveRateOverride(PlayerPedId(), Config.MovementRate[level])
			
			Citizen.Wait(5)
		else
			Citizen.Wait(1000)
		end
	end
end)

local prevPos = nil
Citizen.CreateThread(function()
    Citizen.Wait(2500)
    prevPos = GetEntityCoords(PlayerPedId(), true)
    while true do
        if isBleeding > 0 then
            local player = PlayerPedId()
            if bleedTickTimer >= Config.BleedTickRate and not isInHospitalBed then
                if not IsEntityDead(player) then
                    if isBleeding > 0 then
                        if isBleeding == 1 then
                            SetFlash(0, 0, 100, 100, 100)
                        elseif isBleeding == 2 then
                            SetFlash(0, 0, 100, 250, 100)
                        elseif isBleeding == 3 then
                            SetFlash(0, 0, 100, 500, 100)
                        elseif isBleeding == 4 then
                            SetFlash(0, 0, 100, 500, 100)
                        end

                        if fadeOutTimer + 1 == Config.FadeOutTimer then
                            if blackoutTimer + 1 == Config.BlackoutTimer then
<<<<<<< Updated upstream
                                exports['mythic_notify']:DoCustomHudText('inform', 'You Suddenly Black Out', 5000)
=======
                                exports['mythic_notify']:SendAlert('inform', 'You Suddenly Black Out', 5000)
>>>>>>> Stashed changes
                                SetFlash(0, 0, 100, 7000, 100)

                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end

                                if not IsPedRagdoll(player) and IsPedOnFoot(player) and not IsPedSwimming(player) then
                                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) -- change this float to increase/decrease camera shake
                                    SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(player), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                                end

                                Citizen.Wait(1500)
                                DoScreenFadeIn(1000)
                                blackoutTimer = 0
                            else
                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(0)
                                end
                                DoScreenFadeIn(500)

                                if isBleeding > 3 then
                                    blackoutTimer = blackoutTimer + 2
                                else
                                    blackoutTimer = blackoutTimer + 1
                                end
                            end

                            fadeOutTimer = 0
                        else
                            fadeOutTimer = fadeOutTimer + 1
                        end

                        local bleedDamage = tonumber(isBleeding) * Config.BleedTickDamage
                        ApplyDamageToPed(player, bleedDamage, false)
                        playerHealth = playerHealth - bleedDamage

                        if advanceBleedTimer >= Config.AdvanceBleedTimer then
                            ApplyBleed(1)
                            advanceBleedTimer = 0
                        else
                            advanceBleedTimer = advanceBleedTimer + 1
                        end
                    end
                end
                bleedTickTimer = 0
            else
                if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
                    local currPos = GetEntityCoords(player, true)
                    local moving = #(vector2(prevPos.x, prevPos.y) - vector2(currPos.x, currPos.y))
                    if (moving > 1 and not IsPedInAnyVehicle(player)) and isBleeding > 2 then
                        exports['mythic_notify']:PersistentAlert('start', bleedMoveNotifId, 'inform', 'You notice blood oozing from your wounds faster when you\'re moving', { ['background-color'] = '#4d0e96' })
                        advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
                        bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
                        prevPos = currPos
                    else
                        exports['mythic_notify']:PersistentAlert('end', bleedMoveNotifId)
                        bleedTickTimer = bleedTickTimer + 1
                    end

                else

                end
                bleedTickTimer = bleedTickTimer + 1
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health and health < (playerHealth - Config.HealthDamage)) -- Players health was damaged

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]

            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                local weapon = GetDamagingWeapon(ped)
                if weapon ~= nil then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'LOWER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end

                    if checkDamage then
                        CheckDamage(ped, bone, weapon, (playerHealth - health))
                    end
                end
            end
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Citizen.Wait(100)
    end
end)