using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public enum ReasonCode
	{
		/// <summary>
		/// Initial Usage Load
		/// </summary>
		InitialLoad = 0,

		/// <summary>
		/// We Received Fresh Billed Data From Edi File
		/// </summary>
		ReceivedEdiFile = 1,

		/// <summary>
		/// Conflict In Usage Between Scraped And Edi Sources
		/// </summary>
		ConflictInUsage = 2,

		/// <summary>
		/// Received A Cancel From Edi
		/// </summary>
		ReceivedCancel = 3,

		/// <summary>
		/// Record Inserted From The Framework
		/// </summary>
		InsertedFromFramework = 4,

		/// <summary>
		/// Hierarchical conflict after initial load
		/// </summary>
		HierarchicalConflictAfterInitialLoad = 5,

		/// <summary>
		/// Hierarchical conflict between different sources
		/// </summary>
		HierarchicalConflictBetweenDifferentSources = 6,

		/// <summary>
		/// Exception between different Meter Reads
		/// </summary>
		ExceptionBetweenDifferentMeterReads = 7,

		/// <summary>
		/// Updated Meter Number from Raw Source
		/// </summary>
		UpdatedMeterNumber = 8,

		/// <summary>
		/// Negative Usage
		/// </summary>
		NegativeUsage = 9,

		/// <summary>
		/// Same Begin Date As Previous Meter Read
		/// </summary>
		SameBeginBetweenDifferentMeterReads = 10,

		/// <summary>
		/// Same End Date As Previous Meter Read
		/// </summary>
		SameEndBetweenDifferentMeterReads = 11,

		/// <summary>
		/// Current End-Date Is Less Than Current Start-Date
		/// </summary>
		EndDateLessThanBeginDate = 12,

		/// Current End-Date Is Greater Than Previous Start-Date
		/// </summary>
		EndDateGreaterThanPreviousBegin = 13,

		/// <summary>
		/// Current Start-Date Is Equal to Current End-Date
		/// </summary>
		BeginDateEqualEndDate = 14,

		/// <summary>
		/// Updated Source and/or Type from Raw Source
		/// </summary>
		UpdatedSourceTypeFromRaw = 15,

		/// <summary>
		/// Updated account number (per Utility request) from EDI
		/// </summary>
		UpdatedAccountNumberFromEdi = 16,
		
		/// <summary>
		/// Aggregated Kwh of overlapping ISTA meter reads
		/// </summary>
		AggregatedKwhFromOverlaps = 17,
	}
}
