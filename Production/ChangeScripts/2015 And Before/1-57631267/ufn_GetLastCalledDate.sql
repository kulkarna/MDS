USE [Lp_Enrollment]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetLastCalledDate]    Script Date: 02/25/2013 15:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sadiel Jarvis
-- Create date: 2/25/2013
-- Description:	Given a lead, returns last date begin called by its currently assigned sales channel
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetLastCalledDate]
(
	@p_lead_id int
)
RETURNS datetime
AS
BEGIN
	DECLARE @Result datetime

	SELECT     @Result = min(lc.date_called)
	FROM         lead AS l with (nolock) INNER JOIN
						  lead_call AS lc with (nolock) ON l.lead_id = lc.lead_id and l.channel_id = lc.called_by_id
	WHERE     (l.lead_id = @p_lead_id)

	RETURN @Result
END
