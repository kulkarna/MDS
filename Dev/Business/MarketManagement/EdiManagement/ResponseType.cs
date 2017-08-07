using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	public enum ResponseType
	{
		None = 0,
		EnrollmentReject = 3,
		EnrollmentAccept = 4,
		UtilityDeenrollmentNotification = 6,
		DeenrollmentReject = 7,
		DeenrollmentAccept = 8
	}
}
