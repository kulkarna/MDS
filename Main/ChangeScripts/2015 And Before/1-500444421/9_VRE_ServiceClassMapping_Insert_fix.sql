USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_ServiceClassMapInsert]    Script Date: 03/22/2013 11:34:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_VRE_ServiceClassMapInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
GO

USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_VRE_ServiceClassMapInsert]    Script Date: 03/22/2013 11:34:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_VRE_ServiceClassMapInsert]
(
 @UtilityCode varchar(50) ,
 @ServiceClass varchar(50),
 @RawServiceClass varchar(50) ) 
AS
SET NOCOUNT ON


UPDATE VRE_ServiceClassMapping 
SET IsActive = 0 
WHERE UtilityCode = @UtilityCode AND RawServiceClass = @RawServiceClass

INSERT INTO VRE_ServiceClassMapping (UtilityCode, ServiceClass,  RawServiceClass)
VALUES(@UtilityCode, @ServiceClass,  @RawServiceClass)

SELECT
    ID , UtilityCode, ServiceClass , RawServiceClass, DateCreated , CreatedBy , DateModified , ModifiedBy
FROM
    VRE_ServiceClassMapping 
WHERE
    IsActive = 1
    
SET NOCOUNT OFF

GO

EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'VRE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_VRE_ServiceClassMapInsert'
GO


