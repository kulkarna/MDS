

  CREATE proc [dbo].[usp_EntityIndividualGet] (@EntityID int)  
as  

 select     
   EI.EntityID,    
   EI.Firstname,    
   EI.Lastname,    
   EI.MiddleName,    
   EI.MiddleInitial,    
   EI.Title,    
 EI.SocialSecurityNumber,  
   E.CreatedBy,    
   E.ModifiedBy,  
E.DateCreated,  
E.DateModified,
E.Tag,
 E.StartDate
 from EntityIndividual EI  
inner join Entity E on E.EntityID = EI.EntityID  
 where E.EntityID = @EntityID 

