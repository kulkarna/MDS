-- =============================================
-- Author:		Rick Deigsler
-- Create date: 12/13/2007
-- Description:	Get data for specific sales channel
-- =============================================
CREATE PROCEDURE [dbo].[usp_sales_channel_data_sel]

@p_username			nchar(100),
@p_mils				varchar(6)		OUTPUT,
@p_mils_cap			varchar(6)		OUTPUT,
@p_broker_id		varchar(100)	OUTPUT,
@p_broker_mils		varchar(6)		OUTPUT,
@p_email			varchar(256)	OUTPUT

AS

SELECT	@p_mils = CAST(comm_rate AS varchar(6))
FROM	lp_enrollment..comm_sales_channel_rates
WHERE	sales_channel_role	= @p_username
AND		comm_trans_type_id	= 'COMM'

IF	@p_mils IS NULL SET	@p_mils	= '0'

SELECT	@p_mils_cap = CAST(comm_rate AS varchar(6))
FROM	lp_enrollment..comm_sales_channel_rates
WHERE	sales_channel_role = @p_username
AND		comm_trans_type_id	= 'COMMCAP'

IF	@p_mils_cap IS NULL SET	@p_mils_cap	= '0'

SELECT	@p_broker_id = UPPER(broker_id)
FROM	lp_enrollment..comm_sales_channel
WHERE	sales_channel_role = @p_username

IF	@p_broker_id IS NULL OR LEN(RTRIM(LTRIM(@p_broker_id))) = 0 SET @p_broker_id = 'NONE'

SELECT	@p_broker_mils = CAST(comm_broker_rate AS varchar(6))
FROM	lp_enrollment..comm_sales_channel_rates
WHERE	sales_channel_role = @p_username
AND		comm_trans_type_id	= 'COMM'

IF	@p_broker_mils IS NULL SET	@p_broker_mils	= '0'

SET	@p_username = REPLACE(@p_username, 'sales channel/', 'libertypower\')

SELECT	@p_email = Email
FROM	lp_portal..Users
WHERE	Username = @p_username

SELECT	r.RoleID
FROM	lp_portal..UserRoles r INNER JOIN lp_portal..Users u ON r.UserID = u.UserID
WHERE	u.Username = @p_username


