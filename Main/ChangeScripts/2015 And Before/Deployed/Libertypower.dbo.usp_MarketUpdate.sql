
USE [LibertyPower]
GO

BEGIN TRANSACTION CONSTRUCTION
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

--exec usp_MarketUpdate @p_username = 'SSCOTT',@p_retail_mkt_id = 'CA', 'NY WM-01', 'NY WM-01', '6122473-UPD',0 , 0

IF OBJECT_ID ( '[dbo].[usp_MarketUpdate]', 'P' ) IS NOT NULL 
    DROP PROCEDURE [dbo].[usp_MarketUpdate]
GO

CREATE PROCEDURE [dbo].[usp_MarketUpdate]
(
 @p_username					NCHAR(100)
,@p_retail_mkt_id				CHAR(2) = NULL
,@MarketID						INT = NULL
,@p_retail_mkt_descp			VARCHAR(50)
,@p_wholesale_mkt_id			CHAR(10)
,@p_puc_certification_number	VARCHAR(10)
--,@p_inactive_ind				CHAR(1)
--,@p_old_chgstamp				SMALLINT = 0
,@p_error						CHAR(1) = ' '
,@p_msg_id						CHAR(8) = ' '
,@p_descp						VARCHAR(250) = ' '
,@p_result_ind					CHAR(01) = 'Y'
)
AS

-- =============================================
-- Author:		Sheri Scott
-- Create date: 05/15/2012
-- Description:	Updates a row in the Market table with input values 
--				by ID (@MarketID) or MarketCode (@p_retail_mkt_id).
-- =============================================

DECLARE @ID INT

SET @p_retail_mkt_descp	= UPPER(@p_retail_mkt_descp)
 
DECLARE @w_error	CHAR(1)
DECLARE @w_msg_id	CHAR(8)
DECLARE @w_descp	VARCHAR(250)
DECLARE @w_return	INT
 
SET @w_error	= 'I'
SET @w_msg_id	= '00000001'
SET @w_descp	= ' '
SET @w_return	= ' '

SET @ID = (SELECT ID FROM WholesaleMarket WHERE WholesaleMktID = @p_wholesale_mkt_id)

IF @@ERROR <> 0 OR @@ROWCOUNT = 0
	BEGIN
	   SET @w_error	= 'E'
	   SET @w_msg_id	= '00000021'
	   SET @w_return	= 1
	   GOTO get_message
	END	

	UPDATE Market 
	SET	 chgstamp = 0
		,RetailMktDescp = @p_retail_mkt_descp
		,WholesaleMktId = @ID
		,PucCertification_number = @p_puc_certification_number
		,Username = @p_username
		,InactiveInd = 0
		,ActiveDate =	GETDATE()
	FROM Market
	WHERE	(@p_retail_mkt_id IS NULL OR MarketCode = @p_retail_mkt_id)
	AND		(@MarketID IS NULL OR ID = @MarketID)
	AND		InactiveInd = 0

get_message:
IF @@error	<> 0 OR @@rowcount	= 0
BEGIN
   IF EXISTS(SELECT * 
             FROM common_retail_market WITH (NOLOCK INDEX = common_retail_market_idx)
             WHERE retail_mkt_id = @p_retail_mkt_id)
   BEGIN
      SET @w_error	= 'E'
      SET @w_msg_id	= '00000003'
      SET @w_return	= 1
   END
   ELSE
   BEGIN
      SET @w_error	= 'E'
      SET @w_msg_id	= '00000004'
      SET @w_return	= 1
   END
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
