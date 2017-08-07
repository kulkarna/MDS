  

CREATE proc [dbo].[usp_EntityIndividualUpdate] (      
      @EntityID int,    
   @FirstName varchar(100),      
     @LastName varchar(100),      
     @MiddleName varchar(100),      
     @MiddleInitial char(1),      
     @Title varchar(100),      
     @SocialSecurityNumber varchar(12),      
     @ModifiedBy int,  
  @Tag varchar(50),  
     @BirthDate datetime      
     )      
      
as      
    
declare @ErrorMessage nvarchar(4000)        
       
BEGIN Transaction        
  BEGIN TRY        
  
 Update Entity Set   
 ModifiedBy =@ModifiedBy ,    
  DateModified = GetDate(),  
   Tag = @Tag ,  
  startDate = @BirthDate  
 where EntityID = @EntityID   
       
  
 UPdate EntityIndividual      
    set  Firstname = @Firstname,    
   Lastname = @Lastname ,    
   MiddleName = @MiddleName,      
   MiddleInitial= @MiddleInitial,      
   Title = @Title,      
   SocialSecurityNumber = @SocialSecurityNumber    
 where EntityID = @EntityID   
   
 Commit  
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
   End Try  
  
    BEGIN CATCH        
  ROLLBACK        
   select @ErrorMessage = ERROR_MESSAGE()        
   Select @ErrorMessage        
        
 END CATCH  
    
      
      
      
    
     
    
  
