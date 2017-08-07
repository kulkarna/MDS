USE [lp_account]
GO

----------
--Created by Rafael Vasques
--Created Date 2013-04-09
--Description Procedure to insert the Detailed results of Scheduled Task EnrollmentSubmission
---------
Create procedure usp_AccountEnrollmentSubmissionLog
	@Account_ID varchar(30),	
	@Result Varchar(30),
	@Error varchar(max) = null	
	as
	begin
	
	insert into AccountEnrollmentSubmissionLog ( Account_ID, Result, Error, DateCreated)
	Values ( @Account_ID, @Result, @Error, GETDATE())
		
	end
	