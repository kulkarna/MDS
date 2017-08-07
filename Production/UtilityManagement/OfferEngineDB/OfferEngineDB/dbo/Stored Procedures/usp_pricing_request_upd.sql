-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/20/2008
-- Description:	Update pricing request record
-- =============================================
CREATE PROCEDURE [dbo].[usp_pricing_request_upd]
@p_id				int,
@p_request_id		nvarchar(50),
@p_customer_name	nvarchar(50)	= '',
@p_opportunity_name	nvarchar(50)	= '',

@p_due_date			datetime		= GETDATE,
@p_creation_date	datetime		= GETDATE,
@p_type				nvarchar(50)	= '',

@p_sales_rep		nvarchar(150)	= '',
@p_status			nvarchar(50)	= '',
@p_total_accounts	numeric(18,0)	= 0,
@p_annual_est_mwh	numeric(18,0)	= 0,
@p_comments			nvarchar(4000)	= '',
@p_change_reason	nvarchar(250)	= '',
@p_hold_time		datetime		= GETDATE,
@p_analyst			nvarchar(100)	= '0',
@p_approve_comments	nvarchar(250)	= '',
@p_approve_date		datetime		= GETDATE

AS

UPDATE  OE_PRICING_REQUEST
SET     REQUEST_ID = @p_request_id ,
        CUSTOMER_NAME = @p_customer_name ,
        OPPORTUNITY_NAME = @p_opportunity_name ,
        
        --below values are specifically excluded from the update
        --DUE_DATE = @p_due_date,
        --CREATION_DATE = @p_creation_date,
        --[TYPE] = @p_type,
        
        SALES_REPRESENTATIVE = @p_sales_rep ,
        [STATUS] = @p_status ,
        TOTAL_NUMBER_OF_ACCOUNTS = @p_total_accounts ,
        ANNUAL_ESTIMATED_MHW = @p_annual_est_mwh ,
        COMMENTS = @p_comments ,
        CHANGE_REASON = @p_change_reason ,
        HOLD_TIME = @p_hold_time ,
        ANALYST = @p_analyst ,
        APPROVE_COMMENTS = @p_approve_comments ,
        APPROVE_DATE = @p_approve_date
WHERE   ID = @p_id

