
/* -----------------------------------------------------------------------------------
   PROCEDURE:    usp_RateChangeSelectByDate

   AUTHOR:       Christopher Evans 5/5/2010 4:07:33 PM
   ----------------------------------------------------------------------------------- */

CREATE PROCEDURE [dbo].[usp_RateChangeSelectByDate]
(
    @Date [datetime]
)
As
BEGIN

	Select U.Firstname, U.Lastname, RC.*         
	FROM [RateChange] RC
	LEFT JOIN [User] U on U.UserID = RC.CreatedBy
	WHERE RC.[DateCreated] >= @Date
	

End


