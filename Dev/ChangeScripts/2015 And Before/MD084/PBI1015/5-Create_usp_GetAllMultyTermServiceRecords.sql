USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAllMultyTermServiceRecords]    Script Date: 09/13/2012 15:45:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/07/2012>
-- Description:	<Select all records from MultiTermWinService table>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAllMultyTermServiceRecords] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ID, LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId
			, RateEndDateAjustedByService, MultiTermWinServiceStatusId, ServiceLastRunDate
			, DateCreated, CreatedBy, DateModified, ModifiedBy
	FROM dbo.MultiTermWinServiceData with (nolock)
END

GO

