
using System;
namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	public class BusinessActivity
	{
		public int BusinessActivityID { get; set; }
		public string Activity { get; set; }
		public int Sequence { get; set; }
		public bool Active { get; set; }
		public DateTime DateCreated { get; set; }
	}
}
