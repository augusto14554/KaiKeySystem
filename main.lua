local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local bodyGyro, bodyVelocity
local speed = 50 -- Velocidade do voo
local direction = Vector3.zero

-- Atualiza direção com base nas teclas WASD
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
	elseif input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
	elseif input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
	elseif input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
	   input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
		direction = Vector3.zero
	end
end)

-- Função que ativa/desativa o voo
local function setFlying(state)
	flying = state

	if flying then
		character = player.Character or player.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.cframe = humanoidRootPart.CFrame
		bodyGyro.Parent = humanoidRootPart

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.velocity = Vector3.zero
		bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = humanoidRootPart

		RunService:BindToRenderStep("FlyLoop", Enum.RenderPriority.Character.Value, function()
			if not flying then return end
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			bodyVelocity.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(direction * speed)
		end)
	else
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
		RunService:UnbindFromRenderStep("FlyLoop")
	end
end


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Carregando script...",
   LoadingSubtitle = "by Ricardo K",
   ShowText = "RoxBour", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Dark Blue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/RzGsaExz8e", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Tab 1", 4483362458) -- Title, Image

Rayfield:Notify({
   Title = "Rox está funcionado!",
   Content = "Criando por Ricardo K",
   Duration = 6.5,
   Image = 4483362458,
})

local HelloworldButton = Tab:CreateButton({
   Name = "Hello world",
   Callback = function()
        print("hello world")
   end,
})

local Fly = Tab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "Fly",
	Callback = function(Value)
		setFlying(Value)
	end,
})

local function setWalkSpeed(speed)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = speed
	end
end

-- Slider de WalkSpeed
local walkspeedslider = Tab:CreateSlider({
	Name = "Walk speed",
	Range = {0, 100},
	Increment = 10,
	Suffix = "Walk speed",
	CurrentValue = 20,
	Flag = "WalkSpeed",
	Callback = function(Value)
		setWalkSpeed(Value)
	end,
})
