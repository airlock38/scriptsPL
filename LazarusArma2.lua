--munição infinita + dano + + automatica + tiro rapido(arma segundaria)

local safada = require(game.Players.LocalPlayer.Backpack.Weapon2)

for a,b in pairs(safada) do
    print(a,b)
end

while wait() do


safada.Semi = false
safada.Ammo = 2
safada.TorsoShot = 100
safada.HeadShot = 100
safada.LimbShot = 100
safada.FireTime = 0.01

end