local localplayer = game.Players.LocalPlayer

localplayer.Chatted:Connect(function(msg)
if msg:lower() == "/caixa" then
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Interact.MysteryBox.Part.CFrame
end
end)