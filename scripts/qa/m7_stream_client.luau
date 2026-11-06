-- QA-only (Studio Play Client). Streaming/perf snapshot at the player's current position: client-side
-- BasePart counts (whole workspace, course, raid parts, guards), memory and 3 s of frame times.
local Stats=game:GetService("Stats");local RS=game:GetService("RunService");local H=game:GetService("HttpService")
local function count(root) if not root then return 0 end;local n=0;for _,d in root:GetDescendants() do if d:IsA("BasePart") then n+=1 end end;return n end
local f={};local c=RS.RenderStepped:Connect(function(dt) table.insert(f,dt) end);task.wait(3);c:Disconnect()
table.sort(f);local sum=0;for _,v in f do sum+=v end
local root=game.Players.LocalPlayer.Character.HumanoidRootPart
local guards=workspace:FindFirstChild("RaidGuards");local nG=0;if guards then nG=#guards:GetChildren() end
return H:JSONEncode({x=math.floor(root.Position.X),workspaceParts=count(workspace),courseParts=count(workspace:FindFirstChild("CargoTestCourse")),
 raidParts=count(workspace:FindFirstChild("RaidParts")),guardModels=nG,guardParts=count(guards),bikes=#workspace.Vehicles:GetChildren(),
 fps=math.floor(#f/math.max(sum,1e-3)*10)/10,p95ms=math.floor((f[math.max(1,math.floor(#f*.95))] or 0)*10000)/10,memMB=math.floor(Stats:GetTotalMemoryUsageMb()),
 streaming=workspace.StreamingEnabled,targetRadius=workspace.StreamingTargetRadius})
