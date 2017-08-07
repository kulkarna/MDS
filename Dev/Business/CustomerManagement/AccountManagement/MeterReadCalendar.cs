using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class MeterReadCalendar
	{
		public System.Int32? calendar_year { get; set; }
		public System.Int32? calendar_month { get; set; }
		public String utility_Id { get; set; }
		public String read_cycle_id { get; set; }
		public System.DateTime? read_date { get; set; }
		public System.DateTime? Read_Month_Date { get; set; }
		public System.DateTime? Read_Start_Date { get; set; }
		public System.DateTime? Read_End_Date { get; set; }
		public System.DateTime Start_Month { get; set; }

		public MeterReadCalendar ()
		{

		}
	}
}
