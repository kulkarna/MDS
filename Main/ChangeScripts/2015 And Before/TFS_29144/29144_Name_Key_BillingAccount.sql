
-------------------------------------------------------------------------------------------
--1. New Table to Hold Account info in lp_deal_Capture Database
--PBI: 29144 1-329067899  - Deal Entry for Utilities with BA and Name Key
-----------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[deal_contract_account_info]') AND type in (N'U'))
DROP TABLE [dbo].[deal_contract_account_info]
GO

USE [Lp_deal_capture]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[deal_contract_account_info](
	[AccountInfoId] [int] IDENTITY(1,1) NOT NULL,
	[account_id] [char](12) NOT NULL,
	[utility_id] [char](15) NOT NULL,
	[name_key] [char](50) NULL,
	[BillingAccount] [varchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[MeterDataMgmtAgent] [varchar](50) NULL,
	[MeterServiceProvider] [varchar](50) NULL,
	[MeterInstaller] [varchar](50) NULL,
	[MeterReader] [varchar](50) NULL,
	[MeterOwner] [varchar](50) NULL,
	[SchedulingCoordinator] [varchar](50) NULL,
 CONSTRAINT [PK_deal_contract_account_info] PRIMARY KEY NONCLUSTERED 
(
	[AccountInfoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[deal_contract_account_info] ADD  CONSTRAINT [DF_deal_contract_account_info_Created]  DEFAULT (getdate()) FOR [Created]
GO

-------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_info_ins_upd]    Script Date: 12/09/2013 11:43:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_info_ins_upd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_account_info_ins_upd]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_info_ins_upd]    Script Date: 12/09/2013 11:43:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/6/2013
-- Description:	Copied the code from LP_Account to lp_Deal_Capture
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/7/2008
-- Description:	
-- =============================================
-- Modify:		: Jose Munoz
-- Modify date	: 06/02/2010
-- Description	: Add "AND utility_id = @p_utility_id" into WHERE CLAUSE.
-- Codigo		: 001
-- =============================================

CREATE PROCEDURE [dbo].[usp_account_info_ins_upd]

@p_account_number	varchar(30),
@p_utility_id		char(15),
@p_fields			varchar(max),
@p_values			varchar(max),
@p_data_types		varchar(max),
@p_separator		varchar(5)

AS
BEGIN

SET NOCOUNT ON;
DECLARE	@w_account_id			char(12),
		@w_separator_field_pos	int,
		@w_separator_value_pos	int,
		@w_separator_type_pos	int,
		@w_field_item			varchar(1000),
		@w_value_item			char(50),
		@w_type_item			varchar(1000),
		@w_action				varchar(6),
		@w_sql					nvarchar(3000),
		@w_field_length			int


-- new deal
SELECT		@w_account_id		= account_id
FROM		lp_deal_capture..deal_contract_account WITH (NOLOCK)
WHERE		account_number		= @p_account_number
AND			utility_id			= @p_utility_id  -- ADD 001
-- renewal

IF @w_account_id IS NULL
	BEGIN
		SELECT		@w_account_id		= account_id
		FROM		lp_account..account WITH (NOLOCK)
		WHERE		account_number		= @p_account_number
		AND			utility_id			= @p_utility_id -- ADD 001
	END

--PRINT	'@w_account_id: ' + @w_account_id
--PRINT	'@w_action: ' + @w_action

SET @p_fields = @p_fields + @p_separator	
SET @p_values = @p_values + @p_separator	
SET @p_data_types = @p_data_types + @p_separator

--PRINT	'@p_fields: ' + @p_fields
--PRINT	'@p_values: ' + @p_values
--PRINT	'@p_data_types: ' + @p_data_types

WHILE PATINDEX('%' + @p_separator + '%' , @p_fields) <> 0 	
	BEGIN	
		SET	@w_sql = ''
		SET	@w_field_length = LEN(@p_fields)

--PRINT	'PATINDEX: ' + CAST(PATINDEX('%' + @p_separator + '%' , @p_fields) AS varchar(30))

		-- fields	  
		SELECT @w_separator_field_pos =  PATINDEX('%' + @p_separator + '%', @p_fields)	  
		SELECT @w_field_item = LEFT(@p_fields, @w_separator_field_pos - 1)			
		IF LEN(@w_field_item) > 0			  
			SELECT @p_fields = STUFF(@p_fields, 1, @w_separator_field_pos + 1, '')

--PRINT	'@p_fields: ' + @p_fields
--PRINT	'@w_field_item: ' + @w_field_item

		-- values
		SELECT @w_separator_value_pos =  PATINDEX('%' + @p_separator + '%', @p_values)	  
		SELECT @w_value_item = LEFT(@p_values, @w_separator_value_pos - 1)			
		IF LEN(@w_value_item) > 0		  
			SELECT @p_values = STUFF(@p_values, 1, @w_separator_value_pos + 1, '')	

--PRINT	'@w_value_item: ' + @w_value_item

		-- data types
		SELECT @w_separator_type_pos =  PATINDEX('%' + @p_separator + '%', @p_data_types)	  
		SELECT @w_type_item = LEFT(@p_data_types, @w_separator_type_pos - 1)			
		IF LEN(@w_type_item) > 0		  
			SELECT @p_data_types = STUFF(@p_data_types, 1, @w_separator_type_pos + 1, '')	

--PRINT	'@w_type_item: ' + @w_type_item

		IF LEN(@w_field_item) > 0	
			BEGIN
				-- insert
				IF NOT EXISTS (	SELECT	NULL
								FROM	deal_contract_account_info
								WHERE	account_id = @w_account_id
							   )
					BEGIN
						SET	@w_sql = @w_sql + 'INSERT INTO deal_contract_account_info (account_id, utility_id, ' + @w_field_item + ') VALUES (''' + @w_account_id + ''', ''' + @p_utility_id + ''', '
						IF @w_type_item = 'bit' OR @w_type_item = 'float' OR @w_type_item = 'money' OR @w_type_item = 'real' OR @w_type_item = 'int' OR @w_type_item = 'bigint' OR @w_type_item = 'smallint' OR @w_type_item = 'tinyint'
							BEGIN
								SET	@w_sql = @w_sql + @w_value_item + ')'
							END
						ELSE
							BEGIN
								SET	@w_sql = @w_sql + '''' + @w_value_item + ''')'
							END
					END	
				-- update
				ELSE
					BEGIN
						SET	@w_sql = @w_sql + 'UPDATE deal_contract_account_info SET ' + @w_field_item + ' = '
						IF @w_type_item = 'bit' OR @w_type_item = 'float' OR @w_type_item = 'money' OR @w_type_item = 'real' OR @w_type_item = 'int' OR @w_type_item = 'bigint' OR @w_type_item = 'smallint' OR @w_type_item = 'tinyint'
							BEGIN
								SET	@w_sql = @w_sql + @w_value_item
							END
						ELSE
							BEGIN
								SET	@w_sql = @w_sql + '''' + @w_value_item + ''''
							END
						SET	@w_sql = @w_sql + ' WHERE account_id = ''' + @w_account_id + ''''
					END	
--PRINT	'@w_sql: ' + @w_sql
				EXEC sp_executesql @w_sql
			END
		IF @w_field_length = LEN(@p_fields)
			RETURN
	
	
	END




SET NOCOUNT OFF;
END;



GO


---------------------------------------------------------------------------------------------

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_info_sel]    Script Date: 12/09/2013 11:29:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_info_sel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_account_info_sel]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_info_sel]    Script Date: 12/09/2013 11:29:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 12/6/2013
-- Description: Copied from LP_Account	
-- =============================================
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 2/8/2008
-- Description:	
-- =============================================
-- Author:		Eric Hernandez
-- Create date: 9/25/2012
-- Description:	Rewritten so that it doesn't use dynamic SQL.
-- =============================================

CREATE PROCEDURE [dbo].[usp_account_info_sel]

@p_account_number		varchar(30)

AS
SET NOCOUNT ON;

DECLARE	@w_account_id			char(12),
		@w_column				varchar(50),
		@w_sql					nvarchar(3000)

SET			@w_sql = ''

-- new deal
SELECT		@w_account_id	= account_id
FROM		lp_deal_capture..deal_contract_account
WHERE		account_number	= @p_account_number

-- renewal
IF @w_account_id IS NULL
	BEGIN
		SELECT		@w_account_id	= AccountIDLegacy
		FROM		LibertyPower.dbo.Account (NOLOCK)
		WHERE		accountnumber	= @p_account_number
	END

SELECT account_id, BillingAccount, Created, CreatedBy, MeterDataMgmtAgent, MeterInstaller, MeterOwner, MeterReader, MeterServiceProvider, name_key, SchedulingCoordinator, utility_id 
FROM deal_contract_account_info (NOLOCK)
WHERE account_id = @w_account_id


SET NOCOUNT OFF;
GO



--------------------------------------------------------------------------------------------





