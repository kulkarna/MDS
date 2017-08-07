-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/12/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_matrix_sel]

@p_load_shape_id	varchar(50)		= '',
@p_term				int				= 0,
@p_flow_start_date	datetime		= '',
@p_zone				varchar(50)		= '',
@p_retail_mkt_id	varchar(50)		= '',
@p_utility_id	varchar(50)			= ''

AS

DECLARE	@w_sql				nvarchar(1000),
		@w_days				int

SET		@w_days =	CASE DATEPART(weekday,GETDATE())
                    WHEN 1 THEN -2
                    WHEN 2 THEN -3
                    ELSE -1 END

SET	@w_sql =	'SELECT		TOP 1 [' + CAST(@p_term AS nvarchar(4)) + ']
				FROM		OE_PRICE_MATRIX
				WHERE		FLOW_START_DATE	= ''' + CAST(CONVERT(datetime, @p_flow_start_date, 120) AS varchar(50)) + '''
				AND			LOAD_SHAPE_ID	= ''' + @p_load_shape_id + '''
				AND			ZONE			= ''' + @p_zone + '''
				AND			MARKET			= ''' + @p_retail_mkt_id + '''
				AND			UTILITY			= ''' + @p_utility_id + '''
				AND			FILE_DATE		>= ''' + CAST(CONVERT(datetime, DATEADD(dd, @w_days, (CAST(DATEPART(mm, GETDATE()) AS varchar(2)) + '/' + CAST(DATEPART(dd, GETDATE()) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, GETDATE()) AS varchar(4)))), 120) AS varchar(50)) + '''
				ORDER BY	FILE_DATE DESC'

--SET	@w_sql =	'SELECT		TOP 1 [' + CAST(@p_term AS nvarchar(4)) + ']
--				FROM		OE_PRICE_MATRIX
--				WHERE		FLOW_START_DATE	= ''' + CAST(CONVERT(datetime, @p_flow_start_date, 120) AS varchar(50)) + '''
--				AND			LOAD_SHAPE_ID	= ''' + @p_load_shape_id + '''
--				AND			ZONE			= ''' + @p_zone + '''
--				AND			MARKET			= ''' + @p_retail_mkt_id + '''
--				AND			UTILITY			= ''' + @p_utility_id + '''
--				ORDER BY	FILE_DATE DESC'

EXEC sp_executesql @w_sql

--PRINT	'days: ' + CAST(@w_days AS varchar(10))
--PRINT	'file date: ' + CAST(CONVERT(datetime, DATEADD(dd, @w_days, (CAST(DATEPART(mm, GETDATE()) AS varchar(2)) + '/' + CAST(DATEPART(dd, GETDATE()) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, GETDATE()) AS varchar(4)))), 120) AS varchar(50))
