USE [lp_common]
GO


INSERT INTO  [lp_common].[dbo].[utility_required_data]
           ([utility_id]
           ,[required_length]
           ,[control_type]
           ,[has_control_data]
           ,[label_text]
           ,[account_info_field]
           ,[field_data_type]
           ,[field_data_length]
           ,[stored_proc_val]
           --,[Created]
          -- ,[CreatedBy]
                )
     VALUES
          ('NSTAR-BOS',4,'TextBox',0,'Name Key:','name_Key','varchar','50','')
		  
		  

INSERT INTO  [lp_common].[dbo].[utility_required_data]
           ([utility_id]
           ,[required_length]
           ,[control_type]
           ,[has_control_data]
           ,[label_text]
           ,[account_info_field]
           ,[field_data_type]
           ,[field_data_length]
           ,[stored_proc_val]
           --,[Created]
          -- ,[CreatedBy]
                )
     VALUES
          ('NSTAR-CAMB',4,'TextBox',0,'Name Key:','name_Key','varchar','50','')

		 

INSERT INTO  [lp_common].[dbo].[utility_required_data]
           ([utility_id]
           ,[required_length]
           ,[control_type]
           ,[has_control_data]
           ,[label_text]
           ,[account_info_field]
           ,[field_data_type]
           ,[field_data_length]
           ,[stored_proc_val]
           --,[Created]
          -- ,[CreatedBy]
                )
     VALUES
          ('NSTAR-COMM',4,'TextBox',0,'Name Key:','name_Key','varchar','50','')
