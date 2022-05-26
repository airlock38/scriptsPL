wait(2)
local cfg= {
    radius = 2000,
    seminuke = true,
}

local enemys = {}
local camera = workspace.CurrentCamera
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local dmgkey

local circle = Drawing.new("Circle")
circle.Radius = cfg.radius
circle.Visible = true

function AddEnemys(mob)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Visible = false
    enemys[mob] = {
       Parente = mob,
       Line = line
    }
end

local fuck
fuck = hookmetamethod(game,"__namecall",function(Self,...)
local args = {...}
if getnamecallmethod() == "InvokeServer" and Self.Name == "UpdateDamageKey" then
   print("Valor do dano")
   dmgkey = args[1]
end
if getnamecallmethod() == "FireServer" and Self.Name == "Damage" and Check() then
   for i,v in pairs(Check()) do
   dmgkey = args[2]
   args[1].Damage = math.huge
   args[1].BodyPart = v.HeadBox
   return fuck(Self,unpack(args))
end
end
return fuck(Self,unpack(args))
end)

function Check()
    local zombie = {}
    local mindist = cfg.radius
    for i,v in pairs(enemys) do
        if v.Line.Visible == true then
            if cfg.seminuke == false then
            if (v.Line.From - v.Line.To).magnitude <= mindist then
                mindist = (v.Line.From - v.Line.To).magnitude
                zombie = {v.Parente}
            end
            elseif cfg.seminuke == true then
              table.insert(zombie,v.Parente)
           end
        end
    end
    if #zombie > 0 then
        return zombie
    end
    return nil
end


for i,v in pairs(workspace.Baddies:GetChildren()) do 
AddEnemys(v)
end

workspace.Baddies.ChildAdded:Connect(function(child)
AddEnemys(child)
end)

workspace.Baddies.ChildRemoved:Connect(function(child)
enemys[child].Line:Remove()
enemys[child] = nil
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for i,v in pairs(enemys) do
        if v.Parente.HeadBox and v.Parente.HeadBox.Position then
        local vec,cam = camera:WorldToScreenPoint(v.Parente.HeadBox.Position)
        
        if cam then
            v.Line.From = circle.Position
            v.Line.To = Vector2.new(vec.X,vec.Y + 36)
            if (v.Line.From - v.Line.To).magnitude <= cfg.radius then
                v.Line.Visible = true
            else
                v.Line.Visible = false
            end
            end
        end
    end
    circle.Position = Vector2.new(mouse.X,mouse.Y + 36)
end)

for i,v in pairs(getgc()) do
    if type(v) == "function" and getfenv(v).script == plr.Character.WeaponScript then
        if debug.getinfo(v).name == "Fire" then
            local pau
            pau = hookfunction(v,function(Self,...)
                print("Checking...")
                print(Check(),dmgkey)
                if Check() and dmgkey then
                print("Firing")
                for a,b in pairs(Check()) do
local args = {
    [1] = {
        ["BodyPart"] = b.HeadBox,
        ["Force"] = 0,
        ["GibPower"] = 0,
        ["Damage"] = math.huge
    },
    [2] = dmgkey
}

b.Humanoid.Damage:FireServer(unpack(args))

                end
                end
                return pau(Self,...)
            end)
        end
    end
end