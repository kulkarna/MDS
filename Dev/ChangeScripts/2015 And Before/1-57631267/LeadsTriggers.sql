USE [Lp_Enrollment]
GO

if not exists(select * from sys.columns 
            where Name = N'Channel_Assigned_Date' and Object_ID = Object_ID(N'lead'))    
begin
  ALTER TABLE [Lp_Enrollment].[dbo].[lead] ADD Channel_Assigned_Date datetime NULL
end

GO

/****** Object:  Trigger [After_Insert_UpdateChannelAssignedDate]    Script Date: 03/19/2013 16:19:56 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[After_Insert_UpdateChannelAssignedDate]'))
DROP TRIGGER [dbo].[After_Insert_UpdateChannelAssignedDate]
GO

/****** Object:  Trigger [dbo].[After_Insert_UpdateChannelAssignedDate]    Script Date: 02/22/2013 17:19:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[After_Insert_UpdateChannelAssignedDate]
   ON  [dbo].[lead]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [Lp_Enrollment].[dbo].[lead]
           ([table_id]
           ,[import_id]
           ,[company_name]
           ,[primary_addr]
           ,[primary_city]
           ,[primary_state]
           ,[primary_zip]
           ,[phone_num]
           ,[sic_id]
           ,[sic_desc]
           ,[ethnicity]
           ,[channel_id]
           ,[disposition_id]
           ,[callback_date]
           ,[date_created]
           ,[created_by]
           ,[date_last_modified]
           ,[account_num]
           ,[referred_by_id]
           ,[color]
           ,[email]
           ,[is_just_imported]
           ,[Channel_Assigned_Date])
		 SELECT 
		   [table_id]
		  ,[import_id]
		  ,[company_name]
		  ,[primary_addr]
		  ,[primary_city]
		  ,[primary_state]
		  ,[primary_zip]
		  ,[phone_num]
		  ,[sic_id]
		  ,[sic_desc]
		  ,[ethnicity]
		  ,[channel_id]
		  ,[disposition_id]
		  ,[callback_date]
		  ,[date_created]
		  ,[created_by]
		  ,[date_last_modified]
		  ,[account_num]
		  ,[referred_by_id]
		  ,[color]
		  ,[email]
		  ,[is_just_imported]
		  ,CASE WHEN [channel_id] is null THEN NULL ELSE GetDate() END
	  FROM Inserted

END

GO

/****** Object:  Trigger [After_Update_UpdateChannelAssignedDate]    Script Date: 03/19/2013 16:20:39 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[After_Update_UpdateChannelAssignedDate]'))
DROP TRIGGER [dbo].[After_Update_UpdateChannelAssignedDate]
GO

CREATE TRIGGER [dbo].[After_Update_UpdateChannelAssignedDate]
   ON  [dbo].[lead]
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE [Lp_Enrollment].[dbo].[lead]
	   SET 
		   [table_id] = i.table_id
		  ,[import_id] = i.import_id
		  ,[company_name] = i.company_name
		  ,[primary_addr] = i.primary_addr
		  ,[primary_city] = i.primary_city
		  ,[primary_state] = i.primary_state
		  ,[primary_zip] = i.primary_zip
		  ,[phone_num] = i.phone_num
		  ,[sic_id] = i.sic_id
		  ,[sic_desc] = i.sic_desc
		  ,[ethnicity] = i.ethnicity
		  ,[channel_id] = i.channel_id
		  ,[disposition_id] = i.disposition_id
		  ,[callback_date] = i.callback_date
		  ,[date_created] = i.date_created
		  ,[created_by] = i.created_by
		  ,[date_last_modified] = i.date_last_modified
		  ,[account_num] = i.account_num
		  ,[referred_by_id] = i.referred_by_id
		  ,[color] = i.color
		  ,[email] = i.email
		  ,[is_just_imported] = i.is_just_imported
		  ,[Channel_Assigned_Date] = (CASE WHEN i.channel_id is null THEN NULL ELSE GetDate() END)
	 FROM    inserted i 
        INNER JOIN [Lp_Enrollment].[dbo].[lead] l ON i.lead_id = l.lead_id 		
END	