

USE [ISTA];
GO



SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- =============================================
-- Fuunction Name:		tvf_BilledUsage
-- Author:			Srikanth Bachina
-- Create date:		03/28/2017
-- Description:		This table valued function returns a record set of  
--					Billed Uages for a Accountnumber,Utility,start and end period.
--
-- Parameters:  
--@Accountnumber- The account number that was passed into the function
--@Utilitycode-	 The Utilitycode  that was passed into the function
--	@StartDate    -	The start date and time of the Billed Usage.
--	@EndDate	    -	The end date and time of the Billed Usage.
--
--
-- Date Modified		TFS/iSupprt ticket number	Modified by			Modification Description
--
--
-- =============================================

CREATE FUNCTION [dbo].[tvf_BilledUsage]
(	
-- Add the parameters for the function here
@Accountnumber as Varchar(50),
@Utilitycode as varchar(50),
@StartDate AS  DATETIME,
@EndDate AS    DATETIME
)
RETURNS TABLE
AS
     RETURN
(
    SELECT AccountNumber,
           Utility,
           UtilityDunsNumber,
           FromDate,
           ToDate,
           MAX(TotalkWh) TotalKwh
    FROM
    (
        SELECT AccountNumber,
               Utility,
               UtilityDunsNumber,
               CASE
                   WHEN DATEDIFF(d, Fromdate, ToDate) < 0
                   THEN DATEADD(d, DATEDIFF(d, Fromdate, ToDate), ToDate)
                   ELSE FromDate
               END AS FromDate,
               ToDate,
               TotalkWh
        FROM ista.dbo.[vw_BilledUsageESG] a WITH (NOLOCK)
        WHERE
				AccountNumber = @Accountnumber
				AND Utility=@Utilitycode
				AND FromDate >= @StartDate
				AND ToDate <= @EndDate
        UNION
        SELECT AccountNumber,
               Utility,
               UtilityDunsNumber,
               FromDate,
               ToDate,
               TotalkWh
        FROM ista.dbo.[vw_BilledUsageOLD] WITH (NOLOCK)
        WHERE AccountNumber = @Accountnumber
				AND Utility=@Utilitycode
				AND FromDate >= @StartDate
				AND ToDate <= @EndDate
    ) AS BilledUsageTemp
    GROUP BY AccountNumber,
             Utility,
             UtilityDunsNumber,
             FromDate,
             ToDate
);

GO