


CREATE proc [dbo].[usp_EntityOrganizationInsert] (           
     @DunsNumber varchar(50),    
	 @CustomerName varchar(100),      
     @TaxID varchar(50),      
     @StartDate DateTime ,      
     @CreatedBy int,  
	@Tag varchar(50)  
  )      
as  

     
Declare @EntityID int   

	

        
  BEGIN Transaction 
   BEGIN TRY


	             
        
		 Insert Entity (EntityType, CreatedBy, ModifiedBy,Tag, StartDate) Values ('O',@CreatedBy,@CreatedBy, @Tag, @StartDate)          
		          
		 select @EntityID =scope_identity()      
			      
			Insert EntityOrganization 
			(      
			 EntityID,     
			DunsNumber,     
			 CustomerName,      
			 TaxID
			)      
			values 
			(      
			  @EntityID,     
			@DunsNumber ,    
			  @CustomerName,      
			  @TaxID
			 )      
		    
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
			exec usp_GetErrorInfo        
		          
		END CATCH           
		  
