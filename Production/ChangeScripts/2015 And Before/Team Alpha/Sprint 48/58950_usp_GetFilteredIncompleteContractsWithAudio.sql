USE [Lp_deal_capture]

IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_GetFilteredIncompleteContractsWithAudio' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_GetFilteredIncompleteContractsWithAudio;
GO


GO
/****** Object:  StoredProcedure [dbo].[usp_GetFilteredIncompleteContractsWithAudio]    Script Date: 01/15/2015 11:07:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author: Satchi Jena
-- Date: 12/09/2014
-- Description: fetch all Tablet Incomplete Contracts with File and reason details
-- History:
-- 01/15/2015: bbakshi
--             PBI: 58950 ,Included parameter @marketid and @zipcode
-- ============================================================================

CREATE PROCEDURE [dbo].[usp_GetFilteredIncompleteContractsWithAudio]
(	
    @startdate DATETIME = NULL
  , @enddate DATETIME = NULL
  , @channelid int = NULL
  , @agentid int = NULL
  , @actionstep int = NULL
  , @marketid int = NULL
  , @zipcode varchar(5) = NULL
)
AS 

BEGIN
--need to uncomment below line for VS to generate output class structure.
--SET FMTONLY OFF;
SET NOCOUNT ON;


select  ti.*,cr.InCompleteContractCancelReasonID,ccr.CancelContractReasonId,ccr.Code,ccr.Description,
dh.document_path,dh.document_name,dh.document_guid,sc.ChannelName,
u.Firstname as AgentFirstName,u.Lastname as AgentLastName,m.MarketCode,pb.IsGas,pb.Name as ProductBrandName,m.ID as MarketID

from lp_deal_capture..TabletIncompleteContract ti (nolock)
JOIN lp_deal_capture..InCompleteContractCancelReason cr (nolock)  on ti.TabletIncompleteContractID=cr.TabletIncompleteContractId
JOIN lp_deal_capture..CancelContractReason ccr (nolock)  on cr.CancelContractReasonId=ccr.CancelContractReasonId
LEFT JOIN libertypower..ProductBrand pb (nolock) on ti.ProductBrandID = pb.ProductBrandID
LEFT JOIN libertypower..Market m (nolock) on ti.RetailMarketID = m.ID
LEFT JOIN libertypower..SalesChannel sc (nolock) on ti.SalesChannelID=sc.ChannelID
LEFT JOIN libertypower..[User] u (nolock) on ti.AgentId = u.UserID
LEFT JOIN lp_documents..document_history dh (nolock) on dh.contract_nbr =ti.ContractNumber and dh.document_type_id=60
LEFT JOIN libertypower..FileContext fc (nolock) on fc.FileGuid = dh.document_guid
where  (ti.CreatedDate >= @startdate OR @startdate is null) AND
       (ti.CreatedDate <= @enddate OR @enddate is null) AND
       (ti.SalesChannelID = @channelid  OR @channelid is null) AND
       (ti.AgentId = @agentid OR @agentid is null) AND
       (Outcome = @actionstep OR @actionstep is null) AND
       (ti.RetailMarketID = @marketid OR @marketid is null)AND
       (SAZip = @zipcode OR @zipcode is null)

Order by ti.CreatedDate desc



	
SET NOCOUNT OFF;	
END

