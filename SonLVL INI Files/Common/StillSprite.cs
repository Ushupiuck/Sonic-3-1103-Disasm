using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S3KObjectDefinitions.AIZ
{
	class AnimatedStillSprite2 : Common.AnimatedStillSprite
	{
		public override void Init(ObjectData data)
		{
			var art = LevelData.ReadFile(
				"../data/AIZ/Misclns.nem", CompressionType.Nemesis);

			BuildSpritesSubtypes(
				new AnimatedStillSpriteData(0, art, 0, 3, false, 6, "Short Ember"),
				new AnimatedStillSpriteData(1, art, 5, 3, false, 6, "Tall Ember"));
		}
	}
}

namespace S3KObjectDefinitions.Common
{
	abstract class AnimatedStillSprite : StillSprite
	{
		public override string Name
		{
			get { return "Animated Decorative Sprite"; }
		}

		protected void BuildSpritesSubtypes(params AnimatedStillSpriteData[] subtypes)
		{
			BuildSpritesSubtypes("../data/mappings/30 - Animated Decorations.asm", subtypes);
		}

		protected class AnimatedStillSpriteData : StillSpriteData
		{
			private byte subtype;

			public override byte SubType
			{
				get { return subtype; }
			}

			public AnimatedStillSpriteData(byte subtype, byte[] art, byte frame, byte pal,
				bool pri, byte depth, string name) : base(art, frame, pal, pri, depth, name)
			{
				this.subtype = subtype;
			}
		}
	}

	abstract class StillSprite : ObjectDefinition
	{
		private Dictionary<byte, SubtypeData> subtypeData;
		private ReadOnlyCollection<byte> subtypes;
		private byte defaultSubtype;
		private Sprite defaultSprite;
		private Sprite[] unknownSprite;

		public override string Name
		{
			get { return "Decorative Sprite"; }
		}

		public override Sprite Image
		{
			get { return defaultSprite; }
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return subtypes; }
		}

		public override byte DefaultSubtype
		{
			get { return defaultSubtype; }
		}

		public override string SubtypeName(byte subtype)
		{
			return subtypeData[subtype].Name;
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			SubtypeData data;
			var sprite = subtypeData.TryGetValue(subtype, out data) ? data.Sprite : unknownSprite;
			return sprite[0];
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			SubtypeData data;
			var sprite = subtypeData.TryGetValue(obj.SubType, out data) ? data.Sprite : unknownSprite;
			return sprite[(obj.XFlip ? 1 : 0) | (obj.YFlip ? 2 : 0)];
		}

		public override Sprite GetDebugOverlay(ObjectEntry obj)
		{
			var bounds = GetSprite(obj).Bounds;
			var overlay = new BitmapBits(bounds.Size);
			overlay.DrawRectangle(LevelData.ColorWhite, 0, 0, bounds.Width - 1, bounds.Height - 1);

			return new Sprite(overlay, bounds.X, bounds.Y);
		}

		public override int GetDepth(ObjectEntry obj)
		{
			SubtypeData data;
			return subtypeData.TryGetValue(obj.SubType, out data) ? data.Depth : 0;
		}

		protected void BuildSpritesSubtypes(params StillSpriteData[] subtypes)
		{
			BuildSpritesSubtypes("../Levels/Misc/Map - Still Sprites.asm", subtypes);
		}

		protected void BuildSpritesSubtypes(string mapfile, params StillSpriteData[] data)
		{
			var map = LevelData.ASMToBin(mapfile, LevelData.Game.MappingsVersion);
			subtypeData = System.Linq.Enumerable.ToDictionary(data, s => s.SubType, s => new SubtypeData
			{
				Name = s.name,
				Depth = s.depth,
				Sprite = BuildFlippedSprites(ObjectHelper.MapToBmp(s.art, map, s.frame, s.pal, s.pri))
			});

			subtypes = new ReadOnlyCollection<byte>(System.Linq.Enumerable.ToArray(subtypeData.Keys));
			defaultSubtype = data[0].SubType;
			defaultSprite = subtypeData[defaultSubtype].Sprite[0];
			unknownSprite = BuildFlippedSprites(ObjectHelper.UnknownObject);
		}

		private Sprite[] BuildFlippedSprites(Sprite sprite)
		{
			var flipX = new Sprite(sprite, true, false);
			var flipY = new Sprite(sprite, false, true);
			var flipXY = new Sprite(sprite, true, true);

			return new[] { sprite, flipX, flipY, flipXY };
		}

		protected class StillSpriteData
		{
			public byte[] art;
			public byte frame;
			public byte pal;
			public bool pri;
			public byte depth;
			public string name;

			public virtual byte SubType
			{
				get { return frame; }
			}

			public StillSpriteData(byte[] art, byte frame, byte pal, bool pri, byte depth, string name)
			{
				this.art = art;
				this.frame = frame;
				this.pal = pal;
				this.pri = pri;
				this.depth = depth;
				this.name = name;
			}
		}

		protected class SubtypeData
		{
			public string Name;
			public int Depth;
			public Sprite[] Sprite;
		}
	}
}
