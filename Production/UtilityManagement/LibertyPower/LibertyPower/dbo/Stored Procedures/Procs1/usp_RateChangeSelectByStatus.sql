




/* ------------------------------------------------------------
   PROCEDURE:    usp_RateChangeSelectByParams

   Description:  Selects a record from table 'usp_RateChangeSelectByParams'
				 And puts values into parameters

   AUTHOR:       Christopher Evans 5/5/2010 4:07:33 PM
   ------------------------------------------------------------ */

CREATE PROCEDURE [dbo].[usp_RateChangeSelectByStatus]
(
    @Status [int]
)
As
BEGIN

	Select U.Firstname, U.Lastname, RC.*         
	FROM [RateChange] RC
	LEFT JOIN [User] U on U.UserID = RC.CreatedBy
	WHERE RC.[Status] = @Status;
	

End




