#region Copyright & License Information
/*
 * Copyright 2007-2020 The OpenRA Developers (see AUTHORS)
 * This file is part of OpenRA, which is free software. It is made
 * available to you under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version. For more
 * information, see COPYING.
 */
#endregion

using System;
using System.Linq;
using OpenRA.Mods.Common;
using OpenRA.Mods.Common.Traits;
using OpenRA.Traits;

namespace OpenRA.Mods.CA.Traits
{
	[Desc("Lets the actor spread resources around it in a circle.")]
	class SeedsResourceCAInfo : ConditionalTraitInfo
	{
		public readonly int Interval = 75;
		public readonly string ResourceType = "Ore";
		public readonly int MaxRange = 100;

		public override object Create(ActorInitializer init) { return new SeedsResourceCA(init.Self, this); }
	}

	class SeedsResourceCA : ConditionalTrait<SeedsResourceCAInfo>, ITick, ISeedableResource
	{
		public new readonly SeedsResourceCAInfo Info;

		readonly ResourceType resourceType;
		readonly ResourceLayer resLayer;

		public SeedsResourceCA(Actor self, SeedsResourceCAInfo info)
			: base(info)
		{
			Info = info;

			resourceType = self.World.WorldActor.TraitsImplementing<ResourceType>()
				.FirstOrDefault(t => t.Info.Type == info.ResourceType);

			if (resourceType == null)
				throw new InvalidOperationException("No such resource type `{0}`".F(info.ResourceType));

			resLayer = self.World.WorldActor.Trait<ResourceLayer>();
		}

		int ticks;

		void ITick.Tick(Actor self)
		{
			if (IsTraitDisabled)
				return;

			if (--ticks <= 0)
			{
				Seed(self);
				ticks = Info.Interval;
			}
		}

		public void Seed(Actor self)
		{
			var cell = Util.RandomWalk(self.Location, self.World.SharedRandom)
				.Take(Info.MaxRange)
				.SkipWhile(p => !self.World.Map.Contains(p) ||
					(resLayer.GetResourceType(p) == resourceType && resLayer.IsFull(p)))
				.Cast<CPos?>().FirstOrDefault();

			if (cell != null && resLayer.CanSpawnResourceAt(resourceType, cell.Value))
				resLayer.AddResource(resourceType, cell.Value, 1);
		}
	}
}
