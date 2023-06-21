local radius = 3
local range = 4000000 // 2000 * 2000
local squadColor = Color( 21, 177, 0 )
local color = Color( 0, 102, 255 )

hook.Add( "DrawPlayerDot", "Faction.MarkMembers", function( ent )
    local ply = LocalPlayer()

    local char = ply:GetCurrentCharacter()
    if not char then return end

    local faction = char:GetFaction()
    if not faction then return end

    local factionId = faction:GetId()

    for _, targetPly in pairs( player.GetHumans() ) do
        if targetPly == ply or targetPly:GetMoveType() == MOVETYPE_NOCLIP or
        targetPly:GetColor().a == 0 or not ply:IsLineOfSightClear( targetPly ) then continue end

        local targetChar = targetPly:GetCurrentCharacter()
        if not targetChar then continue end

        local targetFaction = targetChar:GetFaction()
        if not targetFaction then continue end

        local targetFactionId = targetFaction:GetId()

        local shouldDraw = false
        local colorToDraw

        if targetFactionId == factionId then
            colorToDraw = squadColor
            shouldDraw = true
        elseif table.HasValue( faction:GetSubFactions(), targetFactionId ) or table.HasValue( targetFaction:GetSubFactions(), factionId ) then
            colorToDraw = color
            shouldDraw = true
        else
            for __, f in pairs( Faction:GetCache() ) do
                if not f:IsMainFaction() then continue end
                local subfactions = f:GetSubFactions()
                if table.HasValue( subfactions, targetFactionId ) and table.HasValue( subfactions, factionId ) then
                    colorToDraw = color
                    shouldDraw = true
                    break
                end
            end
        end

        if not shouldDraw then continue end

        local pos = targetPly:EyePos()
        pos.z = pos.z + 10
        pos = pos:ToScreen()

        if targetPly == ent then
            draw.RoundedBox( radius, pos.x - radius, pos.y - 30 - radius, radius * 2, radius * 2, colorToDraw )
        elseif ply:GetPos():DistToSqr( targetPly:GetPos() ) <= range then
            draw.RoundedBox( radius, pos.x - radius, pos.y - radius, radius * 2, radius * 2, colorToDraw )
        end
    end
end )