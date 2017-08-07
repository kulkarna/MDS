
-- =============================================
-- Modified by: Isabelle Tamanini 01/04/2012
-- Bug 3566
-- Added UserGuid as a seach parameter and added
-- UserGuid and UserImage to the select.
-- ============================================= 

CREATE PROC [dbo].[usp_SalesChannelUserGetUser]
(
	@UserID int = NULL,
	@UserGuid nvarchar(255) = NULL
)
AS
BEGIN
	SELECT 
		EI.EntityID, 
		EI.MiddleName,      
		EI.MiddleInitial,      
		EI.Title,      
		EI.SocialSecurityNumber, 
		U.UserID,              
		U.UserName,              
		U.Password,              
		U.Firstname,              
		U.Lastname,              
		U.Email,              
		U.DateCreated,  
		U.DateModified,  
		U.CreatedBy,  
		U.ModifiedBy,  
		U.UserType,  
		U.LegacyID,
		U.IsActive,
		SCU.ChannelID, 
		SCU.ReportsTo,
		U.UserGUID,
		U.UserImage
	FROM [User] U (NOLOCK)
	inner join SalesChannelUser SCU (NOLOCK) on U.UserID = SCU.UserID
	inner join EntityIndividual EI (NOLOCK)  on SCU.EntityID = EI.EntityID  
	inner join Entity E (NOLOCK) on E.EntityID = EI.EntityID 
	WHERE (@UserID is null OR U.UserID = @UserID)
	  AND (@UserGuid is null OR U.UserGuid = @UserGuid)
	  
END
GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserGetUser';

