--[[
   Copyright 2007-2019 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]

	UnitTypes = { "mtnk", "jeep", "mtnk", "htnk", "apc" }
	ProducedUnitTypes =
	{
		{ factory = NodBarracks1, types = { "e1", "e3", "e1", "e4", "e1" } },
		{ factory = NodBarracks2, types = { "e1", "e3", "e1", "e4", "e1" } },
		{ factory = NodBarracks3, types = { "e5", "e5", "e5" } },	
		{ factory = NodFactory1, types = { "stnk", "stnk", "stnk" } },
		{ factory = NodFactory2, types = { "ltnk", "bggy", "ltnk" } },
		{ factory = GDIBarracks1, types = { "e2", "e1", "e2", "e3", "e1", "e1" } },
		{ factory = GDIBarracks2, types = { "e2", "e1", "e2", "e3", "e1", "e1" } },
		{ factory = GDIBarracks3, types = { "e2", "e1", "e2", "e3", "e1", "e1" } },
		{ factory = GDIFactory1, types = { "mtnk", "jeep", "mtnk" } },
		{ factory = GDIFactory2, types = { "mtnk", "htnk", "apc" } }
	}

HelicopterUnitTypes = { "e1", "e2", "e1", "e1", "e2", "e3" };
HelicopterNodTypes = { "e1", "e4", "e1", "e1", "e3", "e3" };

Mig1Waypoints = { Mig11, Mig12, Mig13, Mig14 }
Mig2Waypoints = { Mig21, Mig22, Mig23, Mig24 }

ShipUnitTypes1 = { "htnk" }
ShipUnitTypes2 = { "apc" }
ShipUnitTypes3 = { "e1", "e1", "e1" }
ShipUnitTypes4 = { "jeep" }
ShipUnitTypes5 = { "apc" }
ShipUnitTypes6 = { "mtnk" }
ShipUnitTypes7 = { "mtnk" }

BindActorTriggers = function(a)
	if a.HasProperty("Hunt") then
		if a.Owner == nod then
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.Hunt()
				end
			end)
		else
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.AttackMove(NodTemple.Location)
				end
			end)
		end
	end

	if a.HasProperty("HasPassengers") then
		Trigger.OnPassengerExited(a, function(t, p)
			BindActorTriggers(p)
		end)

		Trigger.OnDamaged(a, function()
			if a.HasPassengers then
				a.Stop()
				a.UnloadPassengers()
			end
		end)
	end
end

SendGDIUnits = function(entryCell, unitTypes, interval)
	local units = Reinforcements.Reinforce(gdi, unitTypes, { entryCell }, interval)
	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	Trigger.OnAllKilled(units, function() SendGDIUnits(entryCell, unitTypes, interval) end)
end

ProduceUnits = function(t)
	local factory = t.factory
	if not factory.IsDead then
		local unitType = t.types[Utils.RandomInteger(1, #t.types + 1)]
		factory.Wait(Actor.BuildTime(unitType))
		factory.Produce(unitType)
		factory.CallFunc(function() ProduceUnits(t) end)
	end
end

SetupNodUnits = function()
	Utils.Do(Map.NamedActors, function(a)
		if a.Owner == nod and a.HasProperty("AcceptsCondition") and a.AcceptsCondition("unkillable") then
			a.GrantCondition("unkillable")
			a.Stance = "Defend"
		end
	end)
end

SetupFactories = function()
	Utils.Do(ProducedUnitTypes, function(production)
		Trigger.OnProduction(production.factory, function(_, a) BindActorTriggers(a) end)
	end)
end

SendMigs = function(waypoints)
	local migEntryPath = { waypoints[1].Location, waypoints[2].Location }
	local migs = Reinforcements.Reinforce(gdi, { "orca" }, migEntryPath, 4)
	Utils.Do(migs, function(mig)
		mig.Move(waypoints[3].Location)
		mig.Move(waypoints[4].Location)
		mig.Destroy()
	end)

	Trigger.AfterDelay(DateTime.Seconds(40), function() SendMigs(waypoints) end)
end

InsertGDIChinookReinforcements = function(entry, hpad)
	local units = Reinforcements.ReinforceWithTransport(gdi, "tran",
		HelicopterUnitTypes, { entry.Location, hpad.Location + CVec.New(1, 2) }, { entry.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), function() InsertGDIChinookReinforcements(entry, hpad) end)
end

ShipGDIUnits1 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes1, { LstEntry1.Location, LstUnload1.Location }, { LstEntry1.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits1)
end

ShipGDIUnits2 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes2, { LstEntry2.Location, LstUnload2.Location }, { LstEntry2.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits2)
end

ShipGDIUnits3 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes3, { LstEntry3.Location, LstUnload3.Location }, { LstEntry3.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits3)
end

ShipGDIUnits4 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes4, { LstEntry4.Location, LstUnload4.Location }, { LstEntry4.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits4)
end

ShipGDIUnits5 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes5, { LstEntry5.Location, LstUnload5.Location }, { LstEntry5.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits5)
end

ShipGDIUnits6 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes6, { LstEntry6.Location, LstUnload6.Location }, { LstEntry6.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits6)
end

ShipGDIUnits7 = function()
	local units = Reinforcements.ReinforceWithTransport(gdi, "lst",
		ShipUnitTypes7, { LstEntry7.Location, LstUnload7.Location }, { LstEntry7.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipGDIUnits7)
end

InsertNodChinookReinforcements = function(entry, hpad)
	local units = Reinforcements.ReinforceWithTransport(nod, "tran",
		HelicopterNodTypes, { entry.Location, hpad.Location + CVec.New(1, 2) }, { entry.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), function() InsertNodChinookReinforcements(entry, hpad) end)
end

ticks = 0
speed = 5

Tick = function()
	ticks = ticks + 1

	local t = (ticks + 45) % (360 * speed) * (math.pi / 180) / speed;
	Camera.Position = viewportOrigin + WVec.New(19200 * math.sin(t), 20480 * math.cos(t), 0)
end

WorldLoaded = function()
	nod = Player.GetPlayer("Nod")
	gdi = Player.GetPlayer("GDI")
	viewportOrigin = Camera.Position
	SetupNodUnits()
	SetupFactories()
	Utils.Do(ProducedUnitTypes, ProduceUnits)
	InsertGDIChinookReinforcements(Chinook1Entry, GDIHelipad1)
	InsertGDIChinookReinforcements(Chinook2Entry, GDIHelipad2)
	InsertGDIChinookReinforcements(Chinook3Entry, Paradrop5)
	InsertGDIChinookReinforcements(Chinook4Entry, Paradrop6)
	InsertNodChinookReinforcements(Mig31, NodHelipad1)
	InsertNodChinookReinforcements(Mig41, NodHelipad2)
	Trigger.AfterDelay(DateTime.Seconds(30), function() SendMigs(Mig1Waypoints) end)
	Trigger.AfterDelay(DateTime.Seconds(30), function() SendMigs(Mig2Waypoints) end)
	SendGDIUnits(Entry1.Location, UnitTypes, 50)
	SendGDIUnits(Entry2.Location, UnitTypes, 50)
	SendGDIUnits(Entry3.Location, UnitTypes, 50)
	SendGDIUnits(Entry4.Location, UnitTypes, 50)
	SendGDIUnits(Entry5.Location, UnitTypes, 50)
	SendGDIUnits(Entry6.Location, UnitTypes, 50)	
	SendGDIUnits(Entry7.Location, UnitTypes, 50)
	SendGDIUnits(Entry8.Location, UnitTypes, 50)	
	ShipGDIUnits1()
	ShipGDIUnits2()
	ShipGDIUnits3()
	ShipGDIUnits4()
	ShipGDIUnits5()
	ShipGDIUnits6()
	ShipGDIUnits7()
end
