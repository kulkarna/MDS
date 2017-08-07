--exec usp_MarketValidation @p_username='SSCOTT',@p_action='U',@p_edit_type='ALL',@MarketID=13,@p_retail_mkt_descp='ILLINOIS',@p_wholesale_mkt_id='6',@p_puc_certification_number='0' 

--exec usp_MarketValidation @p_username='SSCOTT',@p_action='U',@p_edit_type='ALL',@p_retail_mkt_id='IL',@p_retail_mkt_descp='ILLINOIS',@p_wholesale_mkt_id='6',@p_puc_certification_number='0' 

--IF OBJECT_ID ( '[dbo].[usp_MarketValidation]', 'P' ) IS NOT NULL 
--    DROP PROCEDURE [dbo].[usp_MarketValidation]
--GO
 
CREATE PROCEDURE [dbo].[usp_MarketValidation]
(
 @p_username					NCHAR(100)
,@p_action						CHAR(1)
,@p_edit_type					VARCHAR(100)
,@p_retail_mkt_id				CHAR(2) = NULL
,@MarketID						INT = NULL
,@p_retail_mkt_descp			VARCHAR(50)
,@p_wholesale_mkt_id			VARCHAR(10)
,@p_puc_certification_number	VARCHAR(10)
,@p_error						CHAR(1) = ' '
,@p_msg_id						CHAR(8) = ' '
,@p_descp						VARCHAR(250) = ' '
,@p_result_ind					CHAR(1) = 'Y'
)
AS

-- =============================================
-- Author:		Sheri Scott
-- Create date: 05/15/2012
-- Description:	Validates inserts and updates to the Market table.
--				Copied from lp_common and modified for Libertypower database.
--				Also added @MarketID (Market.ID) as alternate input parameter
--				to @p_retail_mkt_id (Market.MarketCode).
-- =============================================
 
DECLARE @w_error	CHAR(1)
DECLARE @w_msg_id	CHAR(8)
DECLARE @w_descp	VARCHAR(250)
DECLARE @w_return	INT
 
SELECT @w_error		= 'I'
SELECT @w_msg_id	= '00000001'
SELECT @w_descp		= ' '
SELECT @w_return	= 0
 
DECLARE @w_application	VARCHAR(20)
SELECT @w_application	= 'COMMON'
 
IF @p_edit_type = 'ALL'
OR @p_edit_type = 'RETAIL_MKT_ID'
BEGIN
 
   IF (@p_retail_mkt_id IS NULL OR @p_retail_mkt_id = ' ') AND (@MarketID IS NULL OR @MarketID = 0)
   BEGIN
      SELECT @w_application	= 'COMMON'
      SELECT @w_error		= 'E'
      SELECT @w_msg_id		= '00000017'
      SELECT @w_return		= 1
      GOTO goto_select
   END
 
   IF @p_action	= 'I'
   BEGIN
      IF EXISTS(SELECT *
                FROM Market WITH (NOLOCK)
                WHERE	(MarketCode IS NULL OR MarketCode = @p_retail_mkt_id)
                AND		(ID IS NULL OR ID = @MarketID)
                AND		InactiveInd = 0)
      BEGIN
         SELECT @w_application	= 'COMMON'
         SELECT @w_error		= 'E'
         SELECT @w_msg_id		= '00000018'
         SELECT @w_return		= 1
         GOTO goto_select
      END
   END
END
 
IF @p_edit_type	= 'ALL'
OR @p_edit_type	= 'RETAIL_MKT_DESCP'
BEGIN
 
   IF @p_retail_mkt_descp IS NULL
   OR @p_retail_mkt_descp = ' '
   BEGIN
      SELECT @w_application	= 'COMMON'
      SELECT @w_error		= 'E'
      SELECT @w_msg_id		= '00000019'
      SELECT @w_return		= 1
      GOTO goto_select
   END

   SELECT @p_retail_mkt_descp = UPPER(@p_retail_mkt_descp)

   IF EXISTS(SELECT *
             FROM Market WITH (NOLOCK)
             WHERE	RetailMktDescp = @p_retail_mkt_descp
             AND	(MarketCode IS NULL OR MarketCode <> @p_retail_mkt_id)
             AND	(ID IS NULL OR ID = @MarketID))
   BEGIN
      SELECT @w_application	= 'COMMON'
      SELECT @w_error		= 'E'
      SELECT @w_msg_id		= '00000025'
      SELECT @w_return		= 1
      GOTO goto_select
   END
 
END
 
IF @p_edit_type = 'ALL'
OR @p_edit_type = 'WHOLESALE_MKT_ID'
BEGIN
 
   IF @p_wholesale_mkt_id IS NULL
   OR @p_wholesale_mkt_id = ' '
   BEGIN
      SELECT @w_application	= 'COMMON'
      SELECT @w_error		= 'E'
      SELECT @w_msg_id		= '00000020'
      SELECT @w_return		= 1
      GOTO goto_select
   END
 
END

IF @p_edit_type = 'ALL'
OR @p_edit_type = 'PUC_CERTIFICATION_NUMBER'
BEGIN
 
   IF @p_wholesale_mkt_id IS NULL
   OR @p_wholesale_mkt_id = ' '
   BEGIN
      SELECT @w_application	= 'COMMON'
      SELECT @w_error		= 'E'
      SELECT @w_msg_id		= '00000020'
      SELECT @w_return		= 1
      GOTO goto_select
   END
 
END
 
goto_select:
 
IF @w_error <> 'N'
BEGIN
   EXEC lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp OUTPUT,
                                    @w_application
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
