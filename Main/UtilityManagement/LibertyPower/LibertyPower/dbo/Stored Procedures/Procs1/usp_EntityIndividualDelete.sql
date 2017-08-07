          
CREATE proc [dbo].[usp_EntityIndividualDelete] (@Firstname varchar(100))            
as            
            
declare @ListToDelete Table            
(            
EntityID int,            
Firstname varchar(100),          
LinkID int            
)            
            
insert into @ListToDelete (EntityID, Firstname, LinkID)            
select EntityID, Firstname , Null            
from  EntityIndividual           
where firstname = @Firstname          
     
	    
	--add the records in the EntityResourceIdentifier table whose EntityID is in the  list.          
	insert into @ListToDelete (EntityID, Firstname, LinkID)            
	select EntityID, null , EL.LinkID         
	from EntityLink EL inner join  EntityResourceIdentifier ERI          
	on EL.LinkID = ERI.LinkID 
    where Address like  '%some%'      
	      
	  
	        
	--add the records in the EntityEmailAddress table whose EntityID is in the  list.          
	insert into @ListToDelete (EntityID, Firstname, LinkID)            
	select EntityID, null , EL.LinkID    
	from EntityLink EL inner join  EntityEmailAddress EMA          
	on EL.LinkID = EMA.LinkID          
	where EMA.Address like '%theTest%' 
	      
	  
	--add the records in the address table whose EntityID is in the  list.          
	insert into @ListToDelete (EntityID, Firstname, LinkID)            
select EntityID, null , EL.LinkID        
	from EntityLink EL inner join  EntityAddress EA          
	on EL.LinkID = EA.LinkID          
	where EA.PostalCode =   '99999'     
	        

	  
	--add the records in the EntityPhone table whose EntityID is in the list.          
	insert into @ListToDelete (EntityID, Firstname, LinkID)            
select EntityID, null , EL.LinkID        
	from EntityLink EL inner join  EntityPhoneNumber EPN          
	on EL.LinkID = EPN.LinkID          
	where EPN.Number  in ('1234567', '3331234')         
	        


	          
	  delete entityGroup            
	where EntityID in (select EntityID from @ListToDelete)      
	  
	      
	  delete entityPhoneNumber            
	where LinkID in (select LinkID from @ListToDelete)            
	           
	  	        
	  delete EntityAddress            
	where LinkID in (select LinkID from @ListToDelete)    

        
	  delete EntityResourceIdentifier            
		where LinkID in (select LinkID from @ListToDelete) 

	   delete EntityEmailAddress            
		where LinkID in (select LinkID from @ListToDelete) 

  
delete EntityLink            
where EntityID in (select EntityID from @ListToDelete)           
          
  
delete EntityIndividual            
where EntityID in (select EntityID from @ListToDelete)            
             
          
delete Entity            
where EntityID in (select EntityID from @ListToDelete)            
            
        ----
