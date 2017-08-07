USE Lp_commissions
GO

SET IDENTITY_INSERT [Lp_commissions].[dbo].[status_list] ON
GO 

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 20 , 'Draft' , 'Draft' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 21 , 'Active' , 'Active' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 22 , 'InActive' , 'InActive' , 'PACKAGES' , 1 , 1 ) 
GO

INSERT INTO [Lp_commissions].[dbo].[status_list] ([status_id], [status_code], [status_descp], [process_id], [is_actionable],[is_modifiable])
VALUES    ( 23 , 'HOLD'	,'Hold'	,'APPROVAL'	, 1 , 1 ) 
GO

SET IDENTITY_INSERT [Lp_commissions].[dbo].[status_list] OFF
GO

