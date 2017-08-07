--Script to include a field ForcePromoCodeUpdate  
--Nov 4 2013
Use GENIE
GO


 if not exists(select * from sys.columns 
            where Name = N'ForcePromoCodeUpdate' and Object_ID = Object_ID(N'LK_DataChangeTracker'))
 Begin
   ALTER TABLE [LK_DataChangeTracker]
ADD [ForcePromoCodeUpdate] bit Null
END
GO

IF Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_LK_DataChangeTracker_ForcePromoCodeUpdate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[LK_DataChangeTracker] ADD  CONSTRAINT [DF_LK_DataChangeTracker_ForcePromoCodeUpdate]  DEFAULT ((0)) FOR [ForcePromoCodeUpdate]
END
GO


--If exists (Select * from [LK_DataChangeTracker] where ForcePromoCodeUpdate=0)
--Begin
--Update [LK_DataChangeTracker] set ForcePromoCodeUpdate=1 
--End
--GO

If exists (Select * from [LK_DataChangeTracker] where ForcePromoCodeUpdate is NuLL)
Begin
Update [LK_DataChangeTracker] set ForcePromoCodeUpdate=1 where ForcePromoCodeUpdate is NuLL
End
GO


