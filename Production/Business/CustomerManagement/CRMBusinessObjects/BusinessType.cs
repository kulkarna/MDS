
using System;
namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	public class BusinessType
	{
		public int BusinessTypeID { get; set; }
		public string Type { get; set; }
		public int Sequence { get; set; }
		public bool Active { get; set; }
		public DateTime DateCreated { get; set; }
	}
}
