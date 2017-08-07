
--Script to drop the referencial Key
--Nov 5 2013

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_T_Qualifier_LK_PromotionCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[T_Qualifier]'))
ALTER TABLE [dbo].[T_Qualifier] DROP CONSTRAINT [FK_T_Qualifier_LK_PromotionCode]
GO