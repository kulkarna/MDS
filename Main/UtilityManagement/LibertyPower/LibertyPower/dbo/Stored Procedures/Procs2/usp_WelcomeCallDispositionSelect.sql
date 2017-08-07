-- =============================================
-- Author:		Sofia Melo
-- Create date: 2010-08-19
-- Description:	Gets the list of Welcome Call Dispositions
-- =============================================
CREATE PROCEDURE [dbo].[usp_WelcomeCallDispositionSelect]
	(      
         
    @call_status varchar(1) = NULL        
)     
   
AS
BEGIN
	
	SET NOCOUNT ON;
    
    if @call_status = NULL
		begin
			SELECT *
			FROM WelcomeCallDisposition
		end
	else 
		begin
			SELECT *
			FROM WelcomeCallDisposition
			WHERE call_status = @call_status
		end
END
