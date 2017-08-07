

-- =============================================
-- Modified by:	Isabelle Tamanini
-- Date:		06/21/2011
-- Adding parameter that will define if the query should retrieve inactive users
-- SD23824 
-- =============================================


CREATE proc [dbo].[usp_SalesChannelUserGetByChannelID_bkp](
	@ChannelID int,
	@IncludeInactive bit = 0
)
as

	Select  EI.EntityID, 
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
			SCU.ReportsTo  
		         
		from [User] U (NOLOCK)
		inner join SalesChannelUser SCU (NOLOCK) on U.UserID = SCU.UserID
		inner join EntityIndividual EI (NOLOCK)  on SCU.EntityID = EI.EntityID  
		inner join Entity E (NOLOCK) on E.EntityID = EI.EntityID 
		where SCU.ChannelID = @ChannelID
		 and (@IncludeInactive = 1 OR U.IsActive = 'Y')
		 order by u.Firstname, u.LastName asc
		 


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelUserGetByChannelID_bkp';

