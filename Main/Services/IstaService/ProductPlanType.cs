using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
	/// <summary>
	/// Enum containing the possible plan types for ISTA
	/// </summary>
	public enum ProductPlanType
	{
		Fixed = 0,				// ISTA's "Fixed"
		PortfolioVarialble = 1, // ISTA's "Portfolio"
		CustomVariable = 2,		// ISTA's "Custom Variable"
		HeatRate = 3,			// ISTA's "HeatRate"
		IndexTexas = 7,			// ISTA's "MCPE"
		BlockIndexed = 5,		// ISTA's "Custom Billing"
		Hybrid = 5,				// ISTA's "Custom Billing"	
		Index = 5,				// ISTA's "Custom Billing"
		Ruc = 6,				// ISTA's "RUC and Congestion"
		CustomIndex = 7			// ISTA's "Custom Index"

	}
}
