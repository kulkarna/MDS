

CREATE proc [dbo].[usp_EntityOrganizationGet] (@EntityID int)  
as  
select     
 E.EntityID,    
 EO.DunsNumber,  
 EO.CustomerName,    
 EO.TaxID,    
 E.CreatedBy,    
 E.ModifiedBy,  
 E.DateCreated,  
 E.DateModified,
 E.Tag,
 E.StartDate   
 from EntityOrganization EO  
inner join Entity E on E.EntityID = EO.EntityID  
 where E.EntityID = @EntityID     
  




