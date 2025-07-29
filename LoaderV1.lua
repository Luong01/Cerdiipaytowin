local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- MAIN UI: ESP List
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "LVM_ESP_UI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 160, 0.45, 0)
frame.Position = UDim2.new(1, -180, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Bo góc + fade in + hover sáng
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
TweenService:Create(frame, TweenInfo.new(0.5), {
	BackgroundTransparency = 0.4
}):Play()
frame.MouseEnter:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {
		BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	}):Play()
end)
frame.MouseLeave:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {
		BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	}):Play()
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "🧠 ESP Tracker"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Layout
local listLayout = Instance.new("UIListLayout", frame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)

-- ESP Logic
local espData = {}

local function updateTeamColor(player)
	local isKiller = player.Team and tostring(player.Team):lower():find("kill")
	local color = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
	return color
end

local function applyESP(player)
	if player == LocalPlayer or espData[player] then return end

	local function setup(char)
		if not char or not char:FindFirstChild("Head") then return end

		local color = updateTeamColor(player)

		-- Highlight
		if not char:FindFirstChild("Highlight") then
			local hl = Instance.new("Highlight", char)
			hl.Name = "Highlight"
			hl.FillTransparency = 0.5
			hl.OutlineTransparency = 1
			hl.Adornee = char
			hl.FillColor = color
		end

		-- Circle ESP
		local head = char:FindFirstChild("Head")
		if head:FindFirstChild("LVM_ESP_Circle") then
			head:FindFirstChild("LVM_ESP_Circle"):Destroy()
		end
		local circleGui = Instance.new("BillboardGui", head)
		circleGui.Name = "LVM_ESP_Circle"
		circleGui.Adornee = head
		circleGui.Size = UDim2.new(0, 100, 0, 40)
		circleGui.AlwaysOnTop = true

		local dot = Instance.new("Frame", circleGui)
		dot.Size = UDim2.new(0, 12, 0, 12)
		dot.Position = UDim2.new(0.5, -6, 0, -14)
		dot.BackgroundColor3 = color
		dot.BorderSizePixel = 0
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		-- UI label
		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -10, 0, 18)
		label.Text = player.Name
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextColor3 = color

		espData[player] = {
			label = label,
			dot = dot,
			char = char,
			updateLoop = task.spawn(function()
				while player and player.Parent and char.Parent do
					local newColor = updateTeamColor(player)
					label.TextColor3 = newColor
					dot.BackgroundColor3 = newColor
					local hl = char:FindFirstChild("Highlight")
					if hl then hl.FillColor = newColor end
					task.wait(1)
				end
				if espData[player] then
					espData[player].label:Destroy()
					espData[player] = nil
				end
			end)
		}
	end

	if player.Character then
		setup(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		setup(char)
	end)
end

-- Apply cho all player
for _, plr in ipairs(Players:GetPlayers()) do
	applyESP(plr)
end
Players.PlayerAdded:Connect(function(plr)
	applyESP(plr)
end)

-- ✅ Watermark gộp chung + fade in/out
local frame2 = Instance.new("Frame", screenGui)
frame2.Size = UDim2.new(0, 160, 0, 24)
frame2.Position = UDim2.new(1, -180, 0.15, 0)
frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame2.BackgroundTransparency = 1
frame2.BorderSizePixel = 0
frame2.Active = true
frame2.Draggable = false
Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 6)

local label = Instance.new("TextLabel", frame2)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "cre: cerdii x LamVi"
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.TextTransparency = 1
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.PaddingLeft = UDim.new(0, 6)

-- Fade in
TweenService:Create(frame2, TweenInfo.new(0.4), {
	BackgroundTransparency = 0.3
}):Play()
TweenService:Create(label, TweenInfo.new(0.4), {
	TextTransparency = 0
}):Play()

-- Fade out sau 5s rồi destroy
task.delay(5, function()
	TweenService:Create(frame2, TweenInfo.new(0.5), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(label, TweenInfo.new(0.5), {
		TextTransparency = 1
	}):Play()
	task.wait(0.6)
	pcall(function()
		frame2:Destroy()
	end)
end)