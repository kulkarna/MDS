USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]    Script Date: 06/10/2016 09:42:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinant_FieldValueBulkInsertWithMappings]