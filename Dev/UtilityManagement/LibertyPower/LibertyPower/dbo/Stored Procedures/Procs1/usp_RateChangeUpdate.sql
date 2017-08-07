/* ------------------------------------------------------------
   PROCEDURE:    usp_RateChangeUpdate

   Description:  Updates a record In table 'usp_RateChangeUpdate'

   AUTHOR:       Christopher Evans 5/5/2010 4:07:33 PM
   ------------------------------------------------------------ */

CREATE PROCEDURE [dbo].[usp_RateChangeUpdate]
(
 @ID [int] ,
 @Status [int] ,
 @StatusNotes [varchar](512) ,
 @ModifiedBy [int] )
AS
BEGIN


      UPDATE
          [RateChange]
      SET
          [Status] = @Status ,
          [StatusNotes] = @StatusNotes ,
          [ModifiedBy] = @ModifiedBy ,
          [DateModified] = getdate()
      WHERE
          [ID] = @ID

	   SELECT U.Firstname, U.Lastname, RC.*         
	   FROM [RateChange] RC
	   LEFT JOIN [User] U on U.UserID = RC.CreatedBy
	   WHERE RC.ID = @ID;
         
END


