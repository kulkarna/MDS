USE [lp_account]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetChangedAccountList]    Script Date: 07/21/2015 05:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_GetChangedAccountList](@ACCOUNTNO VARCHAR(50))  
RETURNS @RESULTITEMS TABLE (  
   ACCOUNTNO VARCHAR(50))   
AS  
BEGIN  
		INSERT INTO @RESULTITEMS(ACCOUNTNO)  
			SELECT DISTINCT ACCOUNTNUMBER AS ACCOUNTNO   
				FROM  
				 (  
  
						SELECT DISTINCT  B.OLD_ACCOUNT_NUMBER AS ACCOUNTNUMBER  
							FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A   
								INNER JOIN  LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) B  
									ON (A.OLD_ACCOUNT_NUMBER=B.OLD_ACCOUNT_NUMBER OR A.OLD_ACCOUNT_NUMBER=B.NEW_ACCOUNT_NUMBER)  
									OR (A.NEW_ACCOUNT_NUMBER=B.OLD_ACCOUNT_NUMBER OR A.NEW_ACCOUNT_NUMBER=B.NEW_ACCOUNT_NUMBER)  
						WHERE (A.OLD_ACCOUNT_NUMBER=@ACCOUNTNO OR A.NEW_ACCOUNT_NUMBER=@ACCOUNTNO)  
				UNION   
   
						SELECT DISTINCT  B.NEW_ACCOUNT_NUMBER AS ACCOUNTNUMBER     
							FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A   
							INNER JOIN  LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) B  
							ON (A.OLD_ACCOUNT_NUMBER=B.OLD_ACCOUNT_NUMBER OR A.OLD_ACCOUNT_NUMBER=B.NEW_ACCOUNT_NUMBER)  
						    OR (A.NEW_ACCOUNT_NUMBER=B.OLD_ACCOUNT_NUMBER OR A.NEW_ACCOUNT_NUMBER=B.NEW_ACCOUNT_NUMBER)  
						WHERE (A.OLD_ACCOUNT_NUMBER=@ACCOUNTNO OR A.NEW_ACCOUNT_NUMBER=@ACCOUNTNO) 
						
				union 
				         Select @ACCOUNTNO AS ACCOUNTNUMBER     		 
				) VW   
    
   RETURN;  
END
