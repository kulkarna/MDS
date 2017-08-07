CREATE PROCEDURE [usp_GetStatusForAccountNumberChange] 
(
@ContractNumber varchar(50)
)
AS 

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Status varchar(6),
			@SubStatus varchar (2) 
			
	SELECT @Status	= '01000'
		,@SubStatus = '10'


	IF EXISTS (
		SELECT 1 FROM WipTaskHeader WTH (NOLOCK)
		JOIN WipTask W (NOLOCK) ON WTH.WipTaskHeaderID = W.WipTaskHeaderID
		JOIN TaskStatus TS (NOLOCK) ON W.TaskStatusID = TS.TaskStatusID
		JOIN WorkFlowTaskLogic WTL (NOLOCK) ON W.WorkFlowTaskID = WTL.WorkFlowTaskID
		JOIN Contract C (NOLOCK) ON C.ContractID = WTH.ContractID
		WHERE WTL.LogicParam	= 'SubmitEnrollment'
		AND StatusName			= 'APPROVED'
		AND C.Number			= @ContractNumber)
		
	BEGIN 
		SELECT @Status	= '05000' 
			,@SubStatus = '10'
	END
	ELSE
	BEGIN
		IF EXISTS (
			SELECT * FROM WipTaskHeader WTH (NOLOCK)
			JOIN WipTask W (NOLOCK) ON WTH.WipTaskHeaderID = W.WipTaskHeaderID
			JOIN TaskStatus TS (NOLOCK) ON W.TaskStatusID = TS.TaskStatusID
			JOIN Contract C (NOLOCK) ON C.ContractID = WTH.ContractID
			WHERE (StatusName = 'ON HOLD' OR StatusName = 'PENDING')
			AND C.Number = @ContractNumber)
			
		BEGIN 
			SELECT @Status	= '01000'
				,@SubStatus = '10'
		END
	END

	IF EXISTS (
		SELECT * FROM WipTaskHeader WTH (NOLOCK)
		JOIN WipTask W (NOLOCK) ON WTH.WipTaskHeaderID = W.WipTaskHeaderID
		JOIN TaskStatus TS (NOLOCK) ON W.TaskStatusID = TS.TaskStatusID
		JOIN Contract C (NOLOCK) ON C.ContractID = WTH.ContractID
		WHERE StatusName = 'REJECTED'
		AND C.Number = @ContractNumber)
		
	BEGIN 
		SELECT @Status	= '999999'
			,@SubStatus = '10'
	END
		
	SELECT @Status, @SubStatus

	SET NOCOUNT OFF;
END 
