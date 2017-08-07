

CREATE FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))        
	Returns @temptable TABLE (items varchar(8000))        
	
as  
      
Begin        
	Declare @idx int        
	Declare @slice varchar(8000)        

	Select @idx = 1        
	if len(@String)<1 or @String is null return        

	While @idx!= 0 Begin        
		Set @idx = charindex(@Delimiter,@String)        
		if @idx!=0        
			set @slice = left(@String,@idx - 1)        
		else        
			set @slice = @String        

		if(len(@slice)>0)   
			insert into @temptable(Items) values(@slice)        

		set @String = right(@String,len(@String) - @idx)        
		if len(@String) = 0 break        
	End    
	
	Return        
End 

