USE [Workspace]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]    Script Date: 2/21/2017 11:23:23 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]
