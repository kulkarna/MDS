


-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/19/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_analyst_pricing_requests_sel]

@p_analyst			varchar(4000),
@p_sort_expression	varchar(500)	= ' ORDER BY REQUEST_ID DESC'

AS

DECLARE	@w_sql		nvarchar(4000)

SET	@w_sql ='
SELECT	ID, REQUEST_ID, 
		ISNULL(CUSTOMER_NAME, '''') AS CUSTOMER_NAME, 
		ISNULL(OPPORTUNITY_NAME, '''') AS OPPORTUNITY_NAME, 
		ISNULL(DUE_DATE, '''') AS DUE_DATE, 
		ISNULL(CREATION_DATE, '''') AS CREATION_DATE,
		ISNULL([TYPE], '''') AS [TYPE], 
		ISNULL(SALES_REPRESENTATIVE, '''') AS SALES_REPRESENTATIVE, 
		ISNULL(STATUS, '''') AS STATUS, 
		ISNULL(TOTAL_NUMBER_OF_ACCOUNTS, 0) AS TOTAL_NUMBER_OF_ACCOUNTS, 
		ISNULL(ANNUAL_ESTIMATED_MHW, 0) AS ANNUAL_ESTIMATED_MHW,
		ISNULL(COMMENTS, '''') AS COMMENTS, 
		ISNULL(CHANGE_REASON, '''') AS CHANGE_REASON, 
		ISNULL(HOLD_TIME, '''') AS HOLD_TIME, 
		ISNULL(ANALYST, '''') AS ANALYST, 
		ISNULL(APPROVE_COMMENTS, '''') AS APPROVE_COMMENTS, 
		ISNULL(APPROVE_DATE, '''') AS APPROVE_DATE,
		ISNULL(ACCOUNT_TYPE, '''') AS ACCOUNT_TYPE,
		ISNULL(REPLACE(REFRESH_STATUS, ''Request Pricing '', ''''), '''') AS REFRESH_STATUS
FROM	OE_PRICING_REQUEST WITH (NOLOCK)
'
+ @p_sort_expression

EXEC sp_executesql @w_sql







