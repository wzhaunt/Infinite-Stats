if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Player = game.Players.LocalPlayer
local PG = Player.PlayerGui

pcall(function()
    for _,v in game:GetService("CoreGui").RobloxPromptGui.promptOverlay:GetChildren() do
        if v.Name == "ErrorPrompt" and v:FindFirstChild("MessageArea") and v.MessageArea:FindFirstChild("ErrorFrame") then
            task.wait(2)

            for _ = 1, 30 do
                game:GetService("TeleportService"):Teleport(536102540, Player)
                task.wait(2)
            end
        end
    end

    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            task.wait(2)

            for _ = 1, 30 do
                game:GetService("TeleportService"):Teleport(536102540, Player)
                task.wait(2)
            end
        end
    end)
end)

local Stop = false
local Temp = Player.Character or Player.CharacterAdded:Wait()

local WaitingForPointSlot
Fixing = false

local BoosterTries = 0
local HardResets = 0

local Successful = 0
local Failed = 0

Finished = false

Last = false

Doing = false

Player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

task.wait(1 + Settings.ExtraTime)

if game.PlaceId == 552500546 then
    task.wait(1)
    repeat

        task.wait(0.5)
        Player.Backpack.Scripter.RemoteEvent:FireServer(PG.Setup.Frame.Side.Race,"up")
        task.wait(0.5)
        if PG.Setup.Frame.Side.Race.Set.Texter.Text == "Namekian" then break end

    until PG.Setup.Frame.Side.Race.Set.Texter.Text == "Namekian"

    Player.Backpack.Scripter.RemoteEvent:FireServer("woah")

    return
end

local function SendNotification(Title, Text, Duration)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = Title,Text = Text,Duration = Duration})
end

local function WaitTill(instance, Text, ExtraTime, npc)
    repeat task.wait() until (instance.Text == Text and Player.PlayerGui.HUD.Bottom.ChatGui.Visible == true)

    if ExtraTime > 0 then
        task.wait(ExtraTime)
    end
end

local function Talk(NPC, Content, WaitTime, Texts, Wait, SkipStop)
    if not Player.Backpack:FindFirstChild("ServerTraits") then
        Player.Backpack:WaitForChild("ServerTraits", 30)
    end

    Player.Backpack.ServerTraits.ChatStart:FireServer(NPC ~= "Korin" and workspace.FriendlyNPCs[NPC] or (NPC == "Korin" and workspace.FriendlyNPCs[NPC].Chat.Chat))

    for idx = 1, #Content do

        if Settings.Mode2 and NPC == "Character Slot Changer" and Texts and Texts ~= true and Texts[idx] == "Change Character Slots?" then
            repeat
                Player.Backpack.ServerTraits.ChatStart:FireServer(workspace.FriendlyNPCs["Character Slot Changer"])
                task.wait()
            until PG.HUD.Bottom.ChatGui.Visible == true
        end

        if Wait then
            WaitTill(Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel, Texts[idx], WaitTime, NPC)
        else
            task.wait(Settings.WaitTimeTalk + 0.250)
        end

        if not SkipStop and Stop then
            repeat task.wait() until not Stop
        end

        if Settings.Mode2 and Texts and Texts ~= true and Texts[idx] == "Change Character Slots?" then
            repeat
                Player.Backpack.ServerTraits.ChatAdvance:FireServer({"Yes"})
                task.wait()
            until PG.HUD.Bottom.ChatGui.TextLabel.Text == "Alright"

            repeat
                Player.Backpack.ServerTraits.ChatAdvance:FireServer({"k"})
                task.wait()
            until PG.HUD.Bottom.ChatGui.TextLabel.Text == "Which slot would you like to play in?"

            task.wait(Settings.WaitTimeSlotChange + 0.150)

            Player.Backpack.ServerTraits.ChatAdvance:FireServer({Content[3]})

            task.delay(1, function()
                if PG.HUD.Bottom.ChatGui.TextLabel.Text == "Which slot would you like to play in?" then
                    Player.Backpack.ServerTraits.ChatAdvance:FireServer({Content[3]})
                end
            end)

            break
        end

        Player.Backpack.ServerTraits.ChatAdvance:FireServer({Content[idx]})
    end
end

if Player.PlayerGui:FindFirstChild("HUD") and not Finished then
    task.wait(0.1)

    Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
        if Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel.Text == "Mr Popo is a nice guy" then
            Stop = true

            task.wait(6 + Settings.CharacterDelayTime)

            if not Settings.IsPointSlotANamekian and Player.Character.Race.Value ~= "Namekian" then
                local Tries = 0

                repeat
                    Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                    task.wait(6)

                    if Tries >= 3 then
                        makefolder("HauntRejoin")
                    end

                    if Player.Character.Race.Value ~= "Namekian" then
                        Tries += 1
                    end

                until Player.Character.Race.Value == "Namekian"

                Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)

            elseif Player.Character.Race.Value == "Namekian" then
                Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                task.wait(6)

                Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)
            end
        end
    end)
end

PG.ChildAdded:Connect(function(Child)
    if Child.Name == "HUD" and not Finished then
        task.wait(0.1)

        Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
            if Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel.Text == "Mr Popo is a nice guy" then
                Stop = true

                task.wait(6 + Settings.CharacterDelayTime)

                if not Settings.IsPointSlotANamekian and Player.Character.Race.Value ~= "Namekian" then
                    local Tries = 0

                    repeat
                        Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                        task.wait(6)

                        if Tries >= 3 then
                            makefolder("FanoutHaunt")
                        end

                        if Player.Character.Race.Value ~= "Namekian" then
                            Tries += 1
                        end

                    until Player.Character.Race.Value == "Namekian"

                    Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)

                elseif Player.Character.Race.Value == "Namekian" then
                    Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                    task.wait(6)

                    Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)
                end
            end
        end)
    end
end)

if not Settings.IsPointSlotANamekian and Player.Character.Race.Value ~= "Namekian" then
    Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)

    task.wait(6)
end

if Player.PlayerGui.HUD.Bottom.Stats.StatPoints.Val.Text == "76" then
    if not Settings.IsPointSlotANamekian and Player.Character.Race.Value == "Namekian" then
        Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)

        task.wait(6)
    end

    Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false)
end

if tonumber(Player.PlayerGui.HUD.Bottom.Stats.StatPoints.Val.Text) >= Settings.MaxPoints then
    Finished = true
    Player.PlayerGui.HUD.Bottom.Stats.Labvel.TextLabel.Text = "MAX POINTS REACHED"

    SendNotification("FanoutHaunt", "Max points reached", 5)
    return
end

if tonumber(Player.PlayerGui.HUD.Bottom.Stats.LVL.Val.Text) < 44 then
    Talk("Bulma", {"k", "Yes", "k"} , Settings.WaitTimeTalk, nil, false)
    task.wait(0.8)

    Talk("Spaceship", {"No", "k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.5)

    Talk("Trunks [Future]", {"k","Yes","k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.8)

    Talk("TimeMachine",{"No", "k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.5)

    workspace.FriendlyNPCs["Quest Giver"]:Destroy()
    workspace.FriendlyNPCs["Quest Giver"]:Destroy()

    Talk("Quest Giver",{"k","Yes","k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.8)

    Talk("NamekianShip",{"k","No","k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.7)

    Talk("Elder Kai",{"k","Yes","k", "k"}, Settings.WaitTimeTalk, nil, false)
    task.wait(0.7)

    Talk("Korin", {"k", "k", "DRINK", "k"}, {"Hello", "When you drink it increases your power!", "*DRINKS*"}, true)
    task.wait(3)

elseif tonumber(Player.PlayerGui.HUD.Bottom.Stats.LVL.Val.Text) == 44 then
    Talk("Korin", {"k", "k", "DRINK", "k"}, {"Hello", "When you drink it increases your power!", "*DRINKS*"}, true)
    task.wait(3)
end

local Conn
Conn = Player.CharacterAdded:Connect(function()
    Player.Character:WaitForChild("HumanoidRootPart", 30)

    repeat
        task.wait()
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(-569.78302, 23.587471, -2883.4939)
    until Player.Character:FindFirstChild("PowerOutput")

    local Conn2
    Conn2 = PG:WaitForChild("HUD", 30).Bottom.ChatGui.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
        Last = tick()

        task.wait(10)

        if tick() - Last >= 10 and BoosterTries < 5 and not Doing then

            Doing = true

            if Finished then
                Conn:Disconnect()
                Conn2:Disconnect()
                return
            end

            HardResets += 1

            if HardResets >= 10 then
                makefolder("FanoutHaunt rejoin")
            end

            Fixing = true
            Stop = true

            Player.Character.Humanoid.Health = 0
            Player.Character.Head:Destroy()

            Player.CharacterAdded:Wait()

            Player.Character:WaitForChild("PowerOutput", 30)

            task.wait(1)

            Stop = false

            local took = "none"

            if WaitingForPointSlot then
                took = "namek"
                Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
            else
                took = "point"
                Talk("Character Slot Changer", {"Yes", "k", Settings.PointSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
            end

            Stop = true

            local Char = Player.Character

            task.delay(6, function()
                Stop = false

                if Player.Character == Char then
                    if took == "namek" then
                        Talk("Character Slot Changer", {"Yes", "k", Settings.PointSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
                    else
                        Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
                    end
                end
            end)

            Player.CharacterAdded:Wait()


            Doing = false
            Fixing = false
        end
    end)
end)

task.spawn(function()
    while true do
        if BoosterTries >= 5 then

            Stop = true

            task.wait(6 + Settings.CharacterDelayTime)

            if not Settings.IsPointSlotANamekian and Player.Character.Race.Value ~= "Namekian" then
                local Tries = 0

                repeat
                    Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                    task.wait(6)

                    if Tries >= 3 then
                        makefolder("HauntRejoin")
                    end

                    if Player.Character.Race.Value ~= "Namekian" then
                        Tries += 1
                    end

                until Player.Character.Race.Value == "Namekian"

                Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)

            elseif Player.Character.Race.Value == "Namekian" then
                Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange + 0.3, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true, true)

                task.wait(6)

                Talk("Start New Game [Redo Character]", {"Yes", "k", "Yes"}, 0.6, nil, false, true)
            end

            break
        end

        task.wait()
    end
end)

while true do
    pcall(function()
        if Player.Character.Race.Value ~= "Namekian" and not Settings.IsPointSlotANamekian then
            task.wait(1)

            Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)

            Player.CharacterAdded:Wait()

            if Fixing then
                repeat task.wait() until not Fixing
            end

            task.wait(0.5)

            Player.Character:WaitForChild("PowerOutput", 30)

            task.wait(Settings.CharacterDelayTime)
        end
    end)

    WaitingForPointSlot = false

    Player.Character.HumanoidRootPart.ChildAdded:Connect(function(Child)
        if Child.Name == "Booster" then
            Failed -= 1
            Successful += 1
            BoosterTries = 0
        end
    end)

    Failed += 1
    BoosterTries += 1

    pcall(function()
        Talk("Character Slot Changer", {"Yes", "k", Settings.PointSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
    end)

    task.wait(Settings.KamiChatDelay)

    if not Player.Backpack:FindFirstChild("ServerTraits") then
        pcall(function()
            Player.Backpack:WaitForChild("ServerTraits", 30)
        end)
    end

    if workspace.FriendlyNPCs:FindFirstChild("KAMI") then
        Player.Backpack.ServerTraits.ChatStart:FireServer(workspace.FriendlyNPCs.KAMI.Chat)
        Player.Backpack.ServerTraits.ChatAdvance:FireServer({"k"})
    elseif game.ReplicatedStorage.Hidden:FindFirstChild("KAMI") then
        Player.Backpack.ServerTraits.ChatStart:FireServer(game.ReplicatedStorage.Hidden.KAMI.Chat)
        Player.Backpack.ServerTraits.ChatAdvance:FireServer({"k"})
    end

    Player.CharacterAdded:Wait()

    if Fixing then
        repeat task.wait() until not Fixing
    end

    task.wait(0.5)

    Player.Character:WaitForChild("PowerOutput", 30)

    task.wait(Settings.CharacterDelayTime)

    local breakk = false

    pcall(function()
        if Player.Character.Race.Value == "Namekian" and not Settings.IsPointSlotANamekian then
            task.wait(1)

            Talk("Character Slot Changer", {"Yes", "k", Settings.PointSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)

            Player.CharacterAdded:Wait()

            if Fixing then
                repeat task.wait() until not Fixing
            end

            task.wait(0.5)

            Player.Character:WaitForChild("PowerOutput", 30)

            task.wait(Settings.CharacterDelayTime)
        end

        if Settings.HideName then
            Player.PlayerGui.HUD:WaitForChild("Bottom", 30).Stats.Namae.Val.Text = "FanoutHaunt"
        end

        Player.PlayerGui.HUD.Bottom.Stats.Visible = true

        local AccuracyRate

        if Successful == 0 or Failed == 0 then
            AccuracyRate = Successful == 0 and "0%" or Failed == 0 and "100%"
        else
            AccuracyRate = string.format("%.2f", (Successful / (Successful + Failed)) * 100) .. "%"
        end

        pcall(function()
            PG.HUD.Bottom.Stats.Labvel.TextLabel.Text = "Haunt's Infinte Stats| ACCURACY RATE : " .. AccuracyRate
        end)

        if tonumber(Player.PlayerGui.HUD.Bottom.Stats.StatPoints.Val.Text) >= Settings.MaxPoints then
            Finished = true

            PG.HUD.Bottom.Stats.Labvel.TextLabel.Text = "Haunt's Infinte Stats | MAX POINTS REACHED | ACCURACY RATE : " .. AccuracyRate

            SendNotification("FanoutHaunt", "Max points reached", 5)
            breakk = true
            return
        end
    end)

    task.spawn(function()
        if Settings.AutoStats then
            for _ = 1, 500 do
                Player.Backpack.ServerTraits.AttemptUpgrade:FireServer(Player.PlayerGui.HUD.Bottom.Stats[Settings.Stat])
            end
        end
    end)

    if breakk then
        break
    end

    WaitingForPointSlot = true

    pcall(function()
        Talk("Character Slot Changer", {"Yes", "k", Settings.NamekSlot}, Settings.WaitTimeSlotChange, {"Change Character Slots?", "Alright", "Which slot would you like to play in?", "Loading!"}, true)
    end)

    Player.CharacterAdded:Wait()

    if Fixing then
        repeat task.wait() until not Fixing
    end

    task.wait(0.5)

    Player.Character:WaitForChild("PowerOutput", 30)

    task.wait(Settings.CharacterDelayTime)
end
