local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local camera = workspace.CurrentCamera

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)

camShake:Start()



local ImagePossibility = {
	"rbxassetid://16833452196",
	"rbxassetid://16833452415",
	"rbxassetid://16833452598",
	"rbxassetid://16833452828",
}

local func, setupval, getinfo, typeof, getgc, next = nil, debug.setupvalue or setupvalue, debug.getinfo or getinfo, typeof, getgc, next

for i,v in next, getgc(false) do
	if typeof(v) == "function" then
		local info = getinfo(v)
		if info.currentline == 54 and info.nups == 2 and info.is_vararg == 0 then
			func = v
			break
		end
	end
end

local function DeathHint(hints, type: string)
	setupval(func, 1, hints)
	if type ~= nil then
		setupval(func, 2, type)
	end
end

--// Important

local maingame = require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)

local TIMER = Instance.new("NumberValue")
TIMER.Value = 1200

function Sound(soundid,parent,pitch,volume,POR)
	local sound = Instance.new("Sound")
	sound.Parent = parent
	sound.SoundId = soundid
	sound.Pitch = pitch
	sound.Volume = volume
	sound.PlayOnRemove = POR
	return sound
end

local TS = game:GetService("TweenService")

--// Dread
local Vignette = game.Players.LocalPlayer.PlayerGui.MainUI.MainFrame.DreadVignette
local CurrentRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
local CRVal = game.ReplicatedStorage.GameData.LatestRoom
local RunStillSalvageable = true

local OSTD = Sound("rbxassetid://11639057440", workspace, 1, 2, false)
OSTD:Play()
Vignette.Size = UDim2.new(5,0,5,0)
Vignette.Visible = true
TS:Create(game.SoundService.Main, TweenInfo.new(3), {
	Volume = 0
}):Play()
wait(3)

TS:Create(game.Lighting.MainColorCorrection, TweenInfo.new(1.75), {
	Saturation = -1
}):Play()

local RandomRot = game:GetService("RunService").RenderStepped:Connect(function()
	Vignette.Rotation = math.random(-360,360)
	Vignette.Position = UDim2.new(
		Random.new():NextNumber(.49,.51),
		0,
		Random.new():NextNumber(.49,.51),
		0
	)
end)

local TimerF = game:GetService("RunService").RenderStepped:Connect(function()
	TIMER.Value = TIMER.Value - 1
	print(TIMER.Value)
	print("bg")
end)

TS:Create(Vignette, TweenInfo.new(1.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
	Size = UDim2.new(1,0,1,0)
}):Play()
camShake:ShakeOnce(3,50,15,.1)

wait(1.75)
camShake:ShakeOnce(10,8,.1,2)


--// Run Out Of Time
TIMER.Changed:Connect(function()
	if TIMER.Value <= 0 then

		--// Make sure that the run cant Be Salvaged (aka you cant despawn dread past this point)
		RunStillSalvageable = false


		TimerF:Disconnect()
		Sound("rbxassetid://6891548543", workspace, 1, 7, true):Destroy()
		TS:Create(OSTD, TweenInfo.new(3), {
			Pitch = 0
		}):Play()
		game:GetService("Debris"):AddItem(OSTD, 3)
		TS:Create(Vignette, TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Size = UDim2.new(2.5,0,2.5,0)
		}):Play()
		camShake:ShakeOnce(7,50,.1,5)
		
		--// Turn Off Lights
		for i, v in pairs(workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:GetDescendants()) do
			if v.Name == "Neon" then
				TS:Create(v, TweenInfo.new(1), {
					Color = Color3.new(0,0,0)
				}):Play()
			end
			if v:IsA("PointLight") or v:IsA("SpotLight") then
				TS:Create(v, TweenInfo.new(1), {
					Range = 0,
					Brightness = 0
				}):Play()
			end
		end


		camShake:ShakeOnce(2,80,.5,60)
		
		local Run = Sound("rbxassetid://3359047385", workspace, .08, 1, true)
		local dis = Instance.new("DistortionSoundEffect")
		dis.Parent = Run
		dis.Level = 1
		local eq = Instance.new("EqualizerSoundEffect")
		eq.Parent = Run
		eq.HighGain = 10
		eq.LowGain = -20
		eq.MidGain = -10
		Run:Destroy()

		wait(10)

		camShake:ShakeOnce(30,80,2,.1)
		TS:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2,Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Contrast = -2
		}):Play()
		TS:Create(Vignette, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(.6,0,.6,0)
		}):Play()


		--// Big Boy Himself

		maingame.stopcam = true

		local dead = game:GetObjects("rbxassetid://16834807322")[1] 
		dead.Parent = workspace
		dead.RushNew.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-350,50),math.random(-7,7),math.random(-350,350))

		local goal = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, dead.RushNew.CFrame.Position)

		TS:Create(workspace.CurrentCamera, TweenInfo.new(1,Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			CFrame = goal,
			FieldOfView = 120
		}):Play()

		TS:Create(dead.RushNew, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
			CFrame = workspace.CurrentCamera.CFrame
		}):Play()

		game:GetService("Debris"):AddItem(dead, 2)


		--// Mods remove this spammer from our lobby
		local TextSpam = game:GetService("RunService").RenderStepped:Connect(function()
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Parent = game.Players.LocalPlayer.PlayerGui.MainUI
			ImageLabel.ZIndex = 8

			ImageLabel.Size = UDim2.new(
				.25,
				0,
				.15,
				0
			)

			ImageLabel.Image = ImagePossibility[math.random(1,#ImagePossibility)]
			ImageLabel.ScaleType = Enum.ScaleType.Fit
			ImageLabel.Rotation = math.random(-5,5)
			ImageLabel.BackgroundTransparency = 1

			ImageLabel.Position = UDim2.new(
				Random.new():NextNumber(0,.9),
				0,
				Random.new():NextNumber(0,.9),
				0
			)
			game:GetService("Debris"):AddItem(ImageLabel,0.1)
			for i = 1, 3 do
				ImageLabel.Position = ImageLabel.Position + UDim2.new(
					Random.new():NextNumber(-0.35,0.35),
					0,
					Random.new():NextNumber(-0.35,0.35),
					0
				)
				task.wait()
			end
		end)

		wait(2)
		game:GetService("ReplicatedStorage").RemotesFolder.CamLock:FireServer()
		camShake:ShakeOnce(9,80,.1,20)
		TextSpam:Disconnect()
		maingame.stopcam = false
		DeathHint({
			"You died to Dread.",
			"Keep a watchful eye on how long you take in every room!",
			"If you take too long in a room, it will attack."
		}, "Blue") -- "Blue" or "Yellow"
		loadstring(game:HttpGet("https://raw.githubusercontent.com/XAtomMaster339871/dkrsoilcfrkjghfhgrthngnrtuyghrtuhngur/main/erfz"))()
		wait(5)
		TS:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2), {
			Contrast = 0.05,
			Saturation = 0.2
		}):Play()
		TS:Create(Vignette, TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(5,0,5,0)
		}):Play()
		RandomRot:Disconnect()
		TS:Create(game.SoundService.Main, TweenInfo.new(3), {
			Volume = 1
		}):Play()
	end
end)


--// Door Open

spawn(function()
	CRVal.Changed:Wait()
	if RunStillSalvageable == true then
		TimerF:Disconnect()
		RandomRot:Disconnect()
		OSTD:Destroy()
		TS:Create(Vignette, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Size = UDim2.new(5,0,5,0)
		}):Play()
		TS:Create(game.Lighting.MainColorCorrection, TweenInfo.new(3), {
			Contrast = 0.05,
			Saturation = 0.2
		}):Play()
		TS:Create(game.SoundService.Main, TweenInfo.new(3), {
			Volume = 1
		}):Play()
		Sound("rbxassetid://11638638410", workspace, 1, 2, true):Destroy()
	end
end)
