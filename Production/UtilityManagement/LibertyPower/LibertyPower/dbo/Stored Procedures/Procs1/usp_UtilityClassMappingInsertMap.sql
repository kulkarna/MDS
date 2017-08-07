
CREATE procedure [dbo].[usp_UtilityClassMappingInsertMap](
	@UtilityID		int
   ,@Driver			varchar(50)
   ,@Resultant		varchar(50)
)
as
Begin
	-- if it already exists, nothing to do
	IF NOT EXISTS (	SELECT	d.ID, d.UtilityID, d.Driver 
					FROM	UtilityClassMappingDeterminants d
					JOIN	UtilityClassMappingResultants r
					ON		r.DeterminantsID = d.ID
					WHERE	d.UtilityID = @UtilityID 
					and		d.Driver = @Driver
					and		r.Result = @Resultant )
	BEGIN
		BEGIN TRANSACTION
		
		DECLARE @DeterminantID INT
		
		SET @DeterminantID = (	SELECT	d.ID
								FROM	UtilityClassMappingDeterminants d
								WHERE	d.UtilityID = @UtilityID 
								AND		d.Driver	= @Driver)
						 
		IF @DeterminantID IS NOT NULL
		BEGIN
		
			INSERT INTO UtilityClassMappingResultants( DeterminantsID, Result) VALUES (@DeterminantID, @Resultant)
		
		END
		ELSE BEGIN
		
			INSERT INTO UtilityClassMappingDeterminants( UtilityID, Driver) VALUES (@UtilityID, @Driver)	
			SET @DeterminantID = SCOPE_IDENTITY()	
			INSERT INTO UtilityClassMappingResultants( DeterminantsID, Result) VALUES (@DeterminantID, @Resultant)
		
		END
				
		IF @@ERROR = 0 
			COMMIT                                                                                                                                       
		ELSE
			ROLLBACK  
	END
END




