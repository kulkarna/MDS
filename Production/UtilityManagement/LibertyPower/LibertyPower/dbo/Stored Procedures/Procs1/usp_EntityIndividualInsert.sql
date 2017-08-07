
    
CREATE proc [dbo].[usp_EntityIndividualInsert] (        
     @EntityType char(1),        
     @FirstName varchar(100),        
     @LastName varchar(100),        
     @MiddleName varchar(100),        
     @MiddleInitial char(1),        
     @Title varchar(100),        
     @SocialSecurityNumber varchar(12),        
     @CreatedBy int,    
  @Tag varchar(50) ,  
 @BirthDate datetime   
     )        
        
as        
declare @ErrorMessage nvarchar(4000)        
Declare @EntityID int        
BEGIN Transaction        
  BEGIN TRY        
 Insert Entity (EntityType, CreatedBy, ModifiedBy,Tag, StartDate) Values (@EntityType,@CreatedBy,@CreatedBy,@Tag, @BirthDate)        
        
 select @EntityID =scope_identity()        
        
 insert EntityIndividual        
  (        
  EntityID,        
  Firstname,        
  Lastname,        
  MiddleName,        
  MiddleInitial,        
  Title,        
  SocialSecurityNumber     
        
  )        
 values        
  (        
  @EntityID,        
  @Firstname,        
  @Lastname,        
  @MiddleName,        
  @MiddleInitial,        
  @Title,        
@SocialSecurityNumber   
           
  )        
  COMMIT         
     
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
E.DateModified ,    
E.Tag,  
 E.StartDate  
 from EntityIndividual EI      
inner join Entity E on E.EntityID = EI.EntityID      
 where E.EntityID = @EntityID        
END TRY        
        
BEGIN CATCH        
ROLLBACK        
 select @ErrorMessage = ERROR_MESSAGE()        
 Select @ErrorMessage        
        
END CATCH        
        
        
        
      
       
