

CREATE proc [dbo].[usp_EntityOrganizationUpdate] (         
     @DunsNumber varchar(50),  
	 @CustomerName varchar(100),    
     @TaxID varchar(50),    
     @StartDate DateTime ,    
     @ModifiedBy int,  
	 @EntityID int,
	@Tag varchar(50))    
as  

declare @ErrorMessage nvarchar(4000)      

      
BEGIN Transaction      
  BEGIN TRY 

  Update Entity Set 
ModifiedBy =@ModifiedBy ,  
 DateModified = GetDate() ,
Tag = @Tag,
StartDate = @StartDate 
where EntityID = @EntityID 

  Update EntityOrganization   
set DunsNumber = @DunsNumber,  
  CustomerName = @CustomerName,  
  TaxID =@TaxID  
      
where EntityID = @EntityID 
COMMIT

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

  END TRY

  BEGIN CATCH      
ROLLBACK      
 select @ErrorMessage = ERROR_MESSAGE()      
 Select @ErrorMessage      
      
END CATCH 
  

