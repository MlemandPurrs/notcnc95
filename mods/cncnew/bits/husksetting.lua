--[[
   Copyright 2007-2020 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]

if Map.LobbyOption("huskscontrol") == "structures" then
	Utils.Do(Map.NamedActors, function(actor)
	  if actor.HasProperty("AcceptsCondition") and actor.AcceptsCondition("huskallowed") then
		actor.GrantCondition("huskallowed")
	  end
	end)
elseif Map.LobbyOption("growthrate") == "normaleco" then
	Utils.Do(Map.NamedActors, function(actor)
	  if actor.Type == "split2" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split3" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "splitblue" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split4" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split8" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split9" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split0" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split01" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split02" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split5" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split51" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "split52" then
		actor.GrantCondition("growthnormal")
	  end
	  if actor.Type == "silotib" then
		actor.GrantCondition("growthnormal")
	  end
	end)
elseif Map.LobbyOption("growthrate") == "fasteco" then
	Utils.Do(Map.NamedActors, function(actor)
	  if actor.Type == "split2" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split3" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "splitblue" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split4" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split8" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split9" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split0" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split01" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split02" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split5" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split51" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "split52" then
		actor.GrantCondition("growthfast")
	  end
	  if actor.Type == "silotib" then
		actor.GrantCondition("growthfast")
	  end
	end)
end