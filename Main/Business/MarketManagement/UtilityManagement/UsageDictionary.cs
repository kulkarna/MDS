namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using System.Runtime.Serialization;

	/// <summary>
	/// Dictionary of usage objects
	/// </summary>
	[Serializable]
	public class UsageDictionary : Dictionary<DateTime, Usage>
	{
		[NonSerialized]
		public Dictionary<DateTime, Usage> target = new Dictionary<DateTime, Usage>();

		[Serializable]
		private class SerializedItem
		{
			public DateTime key;
			public Usage value;
		}

		private List<SerializedItem> data;

		/// <summary>
		/// Constructor needed for serialization
		/// </summary>
		public UsageDictionary() : base() { }

		public UsageDictionary( SerializationInfo si, StreamingContext sc ) : base( si, sc ) { }

		[OnSerializing]
		public void OnSerializing( StreamingContext context )
		{
			data = new List<SerializedItem>();

			foreach( KeyValuePair<DateTime, Usage> item in target )
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
			target = new Dictionary<DateTime, Usage>();

			if( context.Context != null )
			{
				foreach( SerializedItem si in data )
				{
					target.Add( si.key, si.value );
				}
				data = null;
			}
		}
	}
}
