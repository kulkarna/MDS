

CREATE Function [dbo].[GetLossFactor]
(
	@Utility varchar(50),
	@ServiceClass varchar(50),
	@Zone varchar(50)
)

Returns decimal(18,10)

AS

BEGIN
			
	Declare @LossFactor decimal(18,10)
	
	Set @LossFactor = 
	(
		Select 
			Top 1
			m.LossFactor
		From
			UtilityClassMapping m
			Inner Join Utility u On m.UtilityID = u.ID
			Inner Join UtilityZone uz On uz.UtilityID = u.ID
			Inner Join Zone z On z.ID = uz.ZoneID
			Inner Join Voltage v ON m.VoltageID = v.ID
			Inner Join ServiceClass s ON m.ServiceClassID = s.ID		
		Where
			u.UtilityCode = @Utility And
			v.ID = 2 And -- Secondary
			s.ServiceClassCode = @ServiceClass And
			z.ZoneCode = @Zone			
	)
							
	If @LossFactor Is Null
	Begin
		Set @LossFactor = 
		(
			Select 
				Top 1
				m.LossFactor
			From
				UtilityClassMapping m
				Inner Join Utility u On m.UtilityID = u.ID
				Inner Join UtilityZone uz On uz.UtilityID = u.ID
				Inner Join Zone z On z.ID = uz.ZoneID
				Inner Join Voltage v ON m.VoltageID = v.ID
				Inner Join ServiceClass s ON m.ServiceClassID = s.ID		
			Where
				u.UtilityCode = @Utility And
				v.ID = 2 And -- Secondary
				s.ServiceClassCode = @ServiceClass And
				Upper(z.ZoneCode) = 'ALL ELSE'				
		)
	End
	
	If @LossFactor Is Null
	Begin
		Set @LossFactor = 
		(
			Select 
				Top 1
				m.LossFactor
			From
				UtilityClassMapping m
				Inner Join Utility u On m.UtilityID = u.ID
				Inner Join UtilityZone uz On uz.UtilityID = u.ID
				Inner Join Zone z On z.ID = uz.ZoneID
				Inner Join Voltage v ON m.VoltageID = v.ID
				Inner Join ServiceClass s ON m.ServiceClassID = s.ID		
			Where
				u.UtilityCode = @Utility And
				v.ID = 2 And -- Secondary
				Upper(s.ServiceClassCode) = 'ALL ELSE' And
				z.ZoneCode = @Zone		
		)
	End
	
	If @LossFactor Is Null
	Begin
		Set @LossFactor = 
		(
			Select 
				Top 1
				m.LossFactor
			From
				UtilityClassMapping m
				Inner Join Utility u On m.UtilityID = u.ID
				Inner Join UtilityZone uz On uz.UtilityID = u.ID
				Inner Join Zone z On z.ID = uz.ZoneID
				Inner Join Voltage v ON m.VoltageID = v.ID
				Inner Join ServiceClass s ON m.ServiceClassID = s.ID		
			Where
				u.UtilityCode = @Utility And
				v.ID = 2 And -- Secondary
				Upper(s.ServiceClassCode) = 'ALL ELSE' And
				Upper(z.ZoneCode) = 'ALL ELSE'		
		)
	End
	
	If Not @LossFactor Is Null
	Begin
		Set @LossFactor = @LossFactor / 100
	End
	
	Return @LossFactor

END

