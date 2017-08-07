namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using System.Runtime.Serialization;

	[Serializable]
	public class UtilityDictionary : Dictionary<string, Utility>
	{
		[NonSerialized]
		public Dictionary<string, Utility> target = new Dictionary<string, Utility>();

		[Serializable]
		private class SerializedItem
		{
			public string key;
			public Utility value;
		}

		private List<SerializedItem> data;

		/// <summary>
		/// Constructor needed for serialization
		/// </summary>
		public UtilityDictionary() : base() { }

		public UtilityDictionary( SerializationInfo si, StreamingContext sc ) : base( si, sc ) { }

		[OnSerializing]
		public void OnSerializing( StreamingContext context )
		{
			data = new List<SerializedItem>();

			foreach( KeyValuePair<string, Utility> item in target )
			{
				SerializedItem si = new SerializedItem();
				si.key = item.Key;
				si.value = item.Value;
				data.Add( si );
			}
		}

		[OnDeserializing]
		public void OnDeserializing( StreamingContext context )
		{
			target = new Dictionary<string, Utility>();

			if( data != null )
			{
				foreach( SerializedItem si in data )
				{
					target.Add( si.key, si.value );
				}
				data = null;
			}
		}

		public void Add(Utility utility)
		{
			this.Add(utility.Code, utility);
		}
	}
}
