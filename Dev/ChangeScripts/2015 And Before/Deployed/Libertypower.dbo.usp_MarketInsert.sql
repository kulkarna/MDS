USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_MarketInsert]    Script Date: 05/17/2012 09:00:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ( '[dbo].[usp_MarketInsert]', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_MarketInsert]
GO

CREATE PROCEDURE [dbo].[usp_MarketInsert]
(
 @p_username					NCHAR(100)
,@p_retail_mkt_id				CHAR(2)
,@p_retail_mkt_descp			VARCHAR(50)
,@p_wholesale_mkt_id			CHAR(10)
,@p_puc_certification_number	VARCHAR(10)
,@p_error						CHAR(1) = ' '
,@p_msg_id						CHAR(08) = ' '
,@p_descp						VARCHAR(250) = ' '
,@p_result_ind					CHAR(01) = 'Y'
)
AS

-- =============================================
-- Author:		Sheri Scott
-- Create date: 05/15/2012
-- Description:	Inserts a record into the Market table.
-- =============================================

SET @p_retail_mkt_descp = UPPER(@p_retail_mkt_descp)
SET @p_wholesale_mkt_id = (SELECT ID 
								FROM WholesaleMarket 
							   WHERE WholesaleMktId = @p_wholesale_mkt_id)
 
DECLARE @w_error	CHAR(1)
DECLARE @w_msg_id	CHAR(8)
DECLARE @w_descp	VARCHAR(250)
DECLARE @w_return	INT
 
SET @w_error	= 'I'
SET @w_msg_id	= '00000001'
SET @w_descp	= ' '
SET @w_return	= 0

INSERT INTO Market (MarketCode,
					RetailMktDescp,
					WholesaleMktId,
					PucCertification_number,
					DateCreated,
					Username,
					InactiveInd,
					ActiveDate,
					Chgstamp,
					TransferOwnershipEnabled)
SELECT @p_retail_mkt_id,
       @p_retail_mkt_descp,
       @p_wholesale_mkt_id,
       @p_puc_certification_number,
       getdate(),
       @p_username,
       '0',
       getdate(),
       0,
       0
 
IF @@error		<> 0
OR @@rowcount	= 0
BEGIN
   SELECT @w_error	= 'E'
   SELECT @w_msg_id	= '00000002'
   SELECT @w_return	= 1
END
 
IF @w_error <> 'N'
BEGIN
   EXEC lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp OUTPUT
END
 
IF @p_result_ind = 'Y'
BEGIN
   SELECT flag_error	= @w_error,
          code_error	= @w_msg_id,
          message_error	= @w_descp
   GOTO goto_return
END
 
SELECT @p_error		= @w_error,
       @p_msg_id	= @w_msg_id,
       @p_descp		= @w_descp
 
goto_return:
RETURN @w_return
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION CONSTRUCTION
GO

SET NOEXEC OFF
GO
