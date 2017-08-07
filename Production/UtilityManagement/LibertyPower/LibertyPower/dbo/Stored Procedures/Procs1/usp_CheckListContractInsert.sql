
CREATE PROC [dbo].[usp_CheckListContractInsert] 
( @ContractNumber	char(12)
, @Step				int
, @Disposition		nchar(10)
, @CheckListID		int
, @Username			nchar(100)
, @State			int
)

AS 
BEGIN 

	INSERT INTO CheckListContract
           (  ContractNumber
			, Step
			, Disposition
			, CheckListID
			, Username
			, DateCreated 
			, [State]
           )
     VALUES
           (  @ContractNumber
			, @Step	
			, @Disposition
			, @CheckListID
			, @Username 
			, getdate() 
			, @State
           )
END 

