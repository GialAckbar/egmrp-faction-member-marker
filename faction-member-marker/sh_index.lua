if SERVER then
    AddCSLuaFile("cl_faction_member_marker.lua")
end

if CLIENT then
    include("cl_faction_member_marker.lua")
end