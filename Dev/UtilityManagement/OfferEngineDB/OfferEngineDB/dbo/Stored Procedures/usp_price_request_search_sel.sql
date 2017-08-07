
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/28/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_request_search_sel]

@p_pricing_request_id		varchar(50)		= '',
@p_offer_id					varchar(50)		= '',
@p_name						varchar(500)	= '',
@p_account_number			varchar(50)		= '',
@p_sales_rep				varchar(100)	= '',
@p_begin_date				varchar(30),
@p_end_date					varchar(30),
@p_date_span				int				= 0,
@p_price_request_status		varchar(50)		= '',
@p_price_type				varchar(20)		= '',
@p_analyst					varchar(100)	= ''

AS

DECLARE	@w_sql				nvarchar(4000),
		@w_date_begin		varchar(30),
		@w_date_end			varchar(30),
		@w_has_conditions	bit


SET	@w_has_conditions = 0

SET	@p_name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@p_name, ',', ' '),'.', ' '), '''', ''), '&', ' and '), '/', ' '), '\', ' ')

SET	@w_sql	=	'SELECT p.ID, p.REQUEST_ID, p.CUSTOMER_NAME, p.OPPORTUNITY_NAME, p.DUE_DATE, 
				p.CREATION_DATE, p.[TYPE], p.SALES_REPRESENTATIVE, p.STATUS, p.TOTAL_NUMBER_OF_ACCOUNTS, 
				p.ANNUAL_ESTIMATED_MHW, p.COMMENTS, p.CHANGE_REASON, p.HOLD_TIME, p.ANALYST, p.APPROVE_COMMENTS, p.APPROVE_DATE, p.REFRESH_STATUS, p.SALES_CHANNEL
				FROM OE_PRICING_REQUEST p WITH (NOLOCK) LEFT OUTER JOIN OE_PRICING_REQUEST_OFFER o WITH (NOLOCK) ON p.REQUEST_ID = o.REQUEST_ID'

IF LEN(@p_pricing_request_id) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.REQUEST_ID = ''' + @p_pricing_request_id + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.REQUEST_ID = ''' + @p_pricing_request_id + ''''
			END
	END

IF LEN(@p_offer_id) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE o.OFFER_ID = ''' + @p_offer_id + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND o.OFFER_ID = ''' + @p_offer_id + ''''
			END
	END

IF LEN(@p_name) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE (p.CUSTOMER_NAME LIKE ''%' + @p_name + '%'' OR p.OPPORTUNITY_NAME LIKE ''%' + @p_name + '%'')'
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND (p.CUSTOMER_NAME LIKE ''%' + @p_name + '%'' OR p.OPPORTUNITY_NAME LIKE ''%' + @p_name + '%'')'
			END
	END

IF LEN(@p_account_number) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE (p.REQUEST_ID IN (SELECT PRICING_REQUEST_ID AS REQUEST_ID FROM OE_PRICING_REQUEST_ACCOUNTS WITH (NOLOCK) WHERE ACCOUNT_NUMBER = ''' + @p_account_number + '''))'
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND (p.REQUEST_ID IN (SELECT PRICING_REQUEST_ID AS REQUEST_ID FROM OE_PRICING_REQUEST_ACCOUNTS WITH (NOLOCK) WHERE ACCOUNT_NUMBER = ''' + @p_account_number + '''))'
			END
	END

IF LEN(@p_sales_rep) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.SALES_REPRESENTATIVE LIKE ''%' + @p_sales_rep + '%'''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.SALES_REPRESENTATIVE LIKE ''%' + @p_sales_rep + '%'''
			END
	END

-- begin date
	BEGIN
		SET	@p_begin_date = DATEADD(day, -1, @p_begin_date)

		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE CREATION_DATE >= ''' + @p_begin_date + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND CREATION_DATE >= ''' + @p_begin_date + ''''
			END
	END

-- end date
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE CREATION_DATE <= ''' + @p_end_date + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND CREATION_DATE <= ''' + @p_end_date + ''''
			END
	END

IF @p_date_span > 0
	BEGIN
		SET	@w_date_begin = DATEADD(day, 1, GETDATE())
		SET	@w_date_end = DATEADD(day, -@p_date_span, GETDATE())

		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.CREATION_DATE <= ''' + @w_date_begin + ''' AND p.CREATION_DATE >= ''' + @w_date_end + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.CREATION_DATE <= ''' + @w_date_begin + ''' AND p.CREATION_DATE >= ''' + @w_date_end + ''''
			END
	END

IF LEN(@p_price_request_status) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.STATUS = ''' + @p_price_request_status + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.STATUS = ''' + @p_price_request_status + ''''
			END
	END

IF LEN(@p_price_type) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.[TYPE] = ''' + @p_price_type + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.[TYPE] = ''' + @p_price_type + ''''
			END
	END

IF LEN(@p_analyst) > 0
	BEGIN
		IF @w_has_conditions = 0
			BEGIN
				SET	@w_sql = @w_sql + ' WHERE p.ANALYST = ''' + @p_analyst + ''''
				SET	@w_has_conditions = 1
			END
		ELSE
			BEGIN
				SET	@w_sql = @w_sql + ' AND p.ANALYST = ''' + @p_analyst + ''''
			END
	END

SET	@w_sql = @w_sql + 'GROUP BY p.ID, p.REQUEST_ID, p.CUSTOMER_NAME, p.OPPORTUNITY_NAME, p.DUE_DATE, 
								p.CREATION_DATE, p.[TYPE], p.SALES_REPRESENTATIVE, p.STATUS, p.TOTAL_NUMBER_OF_ACCOUNTS, 
								p.ANNUAL_ESTIMATED_MHW, p.COMMENTS, p.CHANGE_REASON, p.HOLD_TIME, p.ANALYST, p.APPROVE_COMMENTS, p.APPROVE_DATE, p.REFRESH_STATUS, p.SALES_CHANNEL 
						ORDER BY p.REQUEST_ID DESC'

print @w_sql
EXEC sp_executesql @w_sql
