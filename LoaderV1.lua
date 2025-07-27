local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI hiển thị bên trái
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "LVM_ESP_UI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0.6, 0)
frame.Position = UDim2.new(0, 10, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🧠 ESP Tracker"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local listLayout = Instance.new("UIListLayout", frame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)

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

		-- UI label bên trái
		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -10, 0, 20)
		label.Text = player.Name
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
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
				-- Cleanup khi player rời game
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

-- Apply cho tất cả player
for _, plr in ipairs(Players:GetPlayers()) do
	applyESP(plr)
end

Players.PlayerAdded:Connect(function(plr)
	applyESP(plr)
end)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Watermark_CerdiiLamVi"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 30)
frame.Position = UDim2.new(0, 10, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "cre: cerdii x LamVi"
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Center
label.PaddingLeft = UDim.new(0, 8)

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Tự xóa sau 5 giây
task.delay(5, function()
	pcall(function()
		gui:Destroy()
	end)
end)
