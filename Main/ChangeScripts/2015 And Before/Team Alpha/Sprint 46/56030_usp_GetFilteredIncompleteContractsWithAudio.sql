USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllContractAccounts]    Script Date: 12/09/2014 15:43:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select 1 from sys.objects where name='usp_GetFilteredIncompleteContractsWithAudio' and type='P')
BEGIN
    DROP PROCEDURE [usp_GetFilteredIncompleteContractsWithAudio]
END
GO
CREATE PROCEDURE [dbo].[usp_GetFilteredIncompleteContractsWithAudio]
(	
   @p_date_start DATETIME = NULL
  , @p_date_end DATETIME = NULL
  , @p_channel_id int = NULL
  , @p_agent_id int = NULL
  ,@p_action_step int =NULL
)
AS 

BEGIN
--need to uncomment below line for VS to generate output class structure.
--SET FMTONLY OFF;
SET NOCOUNT ON;


-- ============================================================================
-- Author: Satchi Jena
-- Date: 12/09/2014
-- Description: fetch all Tablet Incomplete Contracts with File and reason details
-- ============================================================================


--EXEC [dbo].[usp_GetFilteredIncompleteContractsWithAudio]
--EXEC [dbo].[usp_GetFilteredIncompleteContractsWithAudio]   @p_date_start = '2014-10-28'
--  , @p_date_end = null
--  , @p_channel_id= 1263
--  , @p_agent_id = null 
--,@p_action_step=0

declare 
@scriptSQL varchar(max)

select  ti.*,cr.InCompleteContractCancelReasonID,ccr.CancelContractReasonId,ccr.Code,ccr.Description,
dh.document_path,dh.document_name,dh.document_guid,sc.ChannelName,
u.Firstname as AgentFirstName,u.Lastname as AgentLastName,m.MarketCode,pb.IsGas,pb.Name as ProductBrandName
into #IncompleteDetails 
from lp_deal_capture..TabletIncompleteContract ti (nolock)
JOIN lp_deal_capture..InCompleteContractCancelReason cr (nolock)  on ti.TabletIncompleteContractID=cr.TabletIncompleteContractId
JOIN lp_deal_capture..CancelContractReason ccr (nolock)  on cr.CancelContractReasonId=ccr.CancelContractReasonId
LEFT JOIN libertypower..ProductBrand pb (nolock) on ti.ProductBrandID = pb.ProductBrandID
LEFT JOIN libertypower..Market m (nolock) on ti.RetailMarketID = m.ID
LEFT JOIN libertypower..SalesChannel sc (nolock) on ti.SalesChannelID=sc.ChannelID
LEFT JOIN libertypower..[User] u (nolock) on ti.AgentId = u.UserID
LEFT JOIN lp_documents..document_history dh (nolock) on dh.contract_nbr =ti.ContractNumber and dh.document_type_id=60
LEFT JOIN libertypower..FileContext fc (nolock) on fc.FileGuid = dh.document_guid
Order by ti.CreatedDate desc

CREATE INDEX NDX_IncompleteDetailsCreatedDate ON #IncompleteDetails (CreatedDate)

set @scriptSQL = N'select * from #IncompleteDetails WITH (NOLOCK) where 1=1';


if(@p_date_start is not null)
BEGIN 
    SET @scriptSQL = @scriptSQL + ' and CreatedDate >= '''+CONVERT(varchar,@p_date_start,20)+''''
END

if(@p_date_end is not null)
BEGIN
    SET @scriptSQL = @scriptSQL + ' and CreatedDate <='''+ CONVERT(varchar,@p_date_end,20)+''''
END
if(@p_channel_id is not null)
BEGIN
    SET @scriptSQL = @scriptSQL + ' and SalesChannelID = '+ CONVERT(VARCHAR,@p_channel_id)
END
if(@p_agent_id is not null)
BEGIN
    SET @scriptSQL = @scriptSQL + ' and AgentId = '+CONVERT(VARCHAR,@p_agent_id)
END

if(@p_action_step is not null)
BEGIN
    SET @scriptSQL = @scriptSQL + ' and Outcome = '+CONVERT(VARCHAR,@p_action_step)
END

--print @scriptSQL;

exec (@scriptSQL)

DROP TABLE #IncompleteDetails;

	
SET NOCOUNT OFF;	
END

