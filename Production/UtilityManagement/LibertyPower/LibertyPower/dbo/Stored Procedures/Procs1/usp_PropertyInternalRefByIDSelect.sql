

CREATE PROCEDURE usp_PropertyInternalRefByIDSelect
(@Id int ) 
AS 
BEGIN 
	SELECT pir.* 
	FROM LibertyPower..PropertyInternalRef pir 
	WHERE pir.ID = @Id 
END 
