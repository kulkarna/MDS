USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_SalesChannelRepresentativesGetByChannelID]    Script Date: 09/12/2013 10:24:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SalesChannelRepresentativesGetByChannelID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SalesChannelRepresentativesGetByChannelID]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_SalesChannelRepresentativesGetByChannelID]    Script Date: 09/12/2013 10:24:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------
--Added: Sept 12 2013
-- Raju Kallepalli
--Reason: 1-143191371 - Sales Rep Enhancement for Deal Entry
--The sales Representative is selected based on the channelID being passed from the SalesChannel Drop Downlist in Deal Capture
---------------------------------------------------------------
CREATE proc [dbo].[usp_SalesChannelRepresentativesGetByChannelID](
	@ChannelID int
)
as
SET NOCOUNT ON

	SELECT DISTINCT  SalesRep from LIBERTYPOWER..Contract WITH(NOLOCK)
      WHERE  SalesChannelID=@ChannelID 
      ORDER BY SalesRep 
		 

SET NOCOUNT OFF
GO


