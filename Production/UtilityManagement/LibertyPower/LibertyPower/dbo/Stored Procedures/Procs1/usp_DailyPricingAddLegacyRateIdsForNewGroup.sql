	
/*******************************************************************************
 * usp_DailyPricingAddLegacyRateIdsForNewGroup
 *
 *
 ******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************/
 
CREATE PROCEDURE [dbo].[usp_DailyPricingAddLegacyRateIdsForNewGroup]  
	@ChannelGroup int
AS	

Set NoCount on


-- Load All the product configurations
SELECT identity(int,1,1) as TempID
	,pc.MarketId
	,pc.UtilityId
	,pc.ZoneId
	,pc.ServiceClassId
	,pc.SegmentID
	,pc.ChannelTypeId
	,pc.ProductTypeId
	,pc.IsTermRange
	,pc.RelativeStartMonth as MaxRelativeStartMonth
	,OA.Term
	,OA.LowerTerm
	,OA.UpperTerm
	,U.UtilityCode
INTO #ProdConfig
FROM libertypower.dbo.ProductConfiguration pc (NOLOCK)
Join libertypower.dbo.OfferActivation oa (NOLOCK)on oa.ProductConfigurationID = pc.ProductConfigurationID
Join libertypower.dbo.utility u (NOLOCK) on pc.utilityId = u.Id
Order By pc.UtilityId,pc.ZoneId
	,pc.ServiceClassId,OA.Term
	

Declare @previousZone			int
		,@previousSC			int
		,@ZoneScCounter			int
		,@MarketId		       int
		,@UtilityId		       int
		,@ZoneId		       int
		,@ServiceClassId	   int
		,@SegmentID		       int
		,@ChannelTypeId		   int
		,@ProductTypeId		   int
		,@IsTermRange		   int
		,@MaxRelativeStartMonth        int
		,@Term			       int
		,@LowerTerm		       int
		,@UpperTerm		       int
		,@UtilityCode		   varchar(20)
		,@Product_Id		   varchar(20)
		,@NewRate_Id		   int
		,@TempId				int
		,@ProductTempId			int
		,@ChannelGroupId		int
		,@RelativeMonth			int
		,@ProductDesc			varChar(250)
		,@ChannelGroupIdMax		int
		
SET	@ChannelGroupIdMax = @ChannelGroup -- set this to the new channel group id to create rate IDs for
Set @previousZone = 0
Set @previousSC = 0
set @ZoneScCounter = 1

IF Not Exists(Select top 1 * FROM [lp_common].[dbo].[common_product_rate] r (NOLOCK)
			join [LibertyPower].[dbo].[product_transition] t (NOLOCK) on r.product_id = t.product_id and r.rate_id =t.rate_id
			where r.Rate_id like '1' + REPLACE(STR(@ChannelGroupIdMax, 2), SPACE(1), '0') + '%'
  )
  Begin 

	While (select count(*) from #ProdConfig) > 0
		BEGIN
			Select top 1 
				@TempId			= TempId
				,@MarketId		= MarketId		
				,@UtilityId		= UtilityId		
				,@ZoneId		= ZoneId		
				,@ServiceClassId	= ServiceClassId	
				,@SegmentID		= SegmentID		
				,@ChannelTypeId		= ChannelTypeId		
				,@ProductTypeId		= ProductTypeId		
				,@IsTermRange		= IsTermRange		
				,@MaxRelativeStartMonth = MaxRelativeStartMonth 
				,@Term			= Term			
				,@LowerTerm		= LowerTerm		
				,@UpperTerm		= UpperTerm		
				,@UtilityCode		= UtilityCode	 
			From #ProdConfig
			
			Set @previousZone = @ZoneId 
			Set @previousSC = @ServiceClassId	
				
				Select identity(int,1,1) as TempID
					,product_id  
				Into #ProductTemp
				From lp_common..common_product WITH (NOLOCK)
				Where utility_id = @UtilityCode 
				and iscustom=0
				and inactive_ind=0 
				and ((account_type_id=1 AND @SegmentID = 2)--(1=Commercial, 2=Residential)
						OR	(account_type_id=2 AND @SegmentID = 3))
				and ((product_category='fixed' AND @ProductTypeId = 1)
						OR (product_category='variable' AND product_sub_category='fixed adder'AND @ProductTypeId = 3))
							 --(For index do: product_category='variable' and product_sub_category='fixed adder'
				and ((is_flexible=0 AND (@ChannelTypeId = 1 OR @ChannelTypeId = 3))	--(1=ABC,0=Telesales)
						OR (is_flexible=1 AND @ChannelTypeId = 2))
				and ((@IsTermRange = 0 AND product_id not like '%_ss%')
						OR (@IsTermRange = 1 AND product_id like '%_ss%')	)

			
			While (select count(*) from #ProductTemp) > 0
			BEGIN
				Select top 1 
				@ProductTempId = TempID
				,@Product_Id = product_id
				From #ProductTemp
				Declare @CreateRateId bit
				
				If(@Product_Id NOT like '%_fs%')
					begin
						Set @CreateRateId = 1
					end
				Else
					Begin
						If(@Term = 3) -- If the product is Freedom to save, we should only create a 3 month product rate
							Set @CreateRateId = 1
						Else
							Set @CreateRateId = 0
					End
				
				print @Product_Id + '@Term = ' + cast(@Term as varchar(10))  + ' CreateRateId = ' + cast(@CreateRateId as varchar(10))
				
				
				IF (@CreateRateId = 1)
				BEGIN
					Set @RelativeMonth  = @MaxRelativeStartMonth
					Set @ZoneScCounter = 1
					While @RelativeMonth > 0 
					Begin
						Set @ChannelGroupId  = @ChannelGroupIdMax
						--While @ChannelGroupId = @ChannelGroupIdMax 
						--Begin
							Set @NewRate_Id = @ZoneScCounter											--        1
							If @IsTermRange	= 0									
								Set @NewRate_Id = @Term * 100 + @NewRate_Id								--      301
							Else
								Set @NewRate_Id = @UpperTerm * 100 + @NewRate_Id
							Set @NewRate_Id = @RelativeMonth * 10000 + @NewRate_Id						--    60301
							Set @NewRate_Id = @ChannelGroupId * 1000000 + @NewRate_Id					--  1060301
							Set @NewRate_Id = 100000000 + @NewRate_Id									--101060301	
							
							-- Loop through until you find the next available incriment.
							While (Select count(*) From lp_common..Common_Product_Rate WITH (NOLOCK) Where Product_id = @Product_Id AND Rate_id = @NewRate_Id) > 0 
								Begin
									print 'duplicate *****************************************************************'
									Set @NewRate_Id = @NewRate_Id + 1
									Set @ZoneScCounter = @NewRate_Id % 100
								End
								
							
							declare @zoneCode varchar(20), @ScCode varchar(20)
							Select @zoneCode = Zone from lp_common..Zone WITH (NOLOCK) where Utility_id = @UtilityCode and ZONE_ID = @ZoneId
							Select @ScCode = service_Rate_class from lp_common..service_Rate_class WITH (NOLOCK) where Utility_id = @UtilityCode and service_Rate_class_id = @ServiceClassId
							Set @ScCode = COALESCE(@ScCode, '')

							If @IsTermRange	= 0	
								Begin											
									Set @ProductDesc = Cast(@Term as varchar(10)) + ' Month ' + @zoneCode + ' ' + @ScCode
								End
							Else
								Begin
									Set @ProductDesc = Cast(@LowerTerm as varchar(10)) + ' to ' + Cast(@UpperTerm as varchar(10)) + ' Month ' + @zoneCode + ' ' + @ScCode
								End
								
		print @Product_Id + '|' + cast(@NewRate_Id as varchar(10)) + ' , ' +  @ProductDesc + ' , ' + ' , ' + cast(@Term as varchar(10)) + ' , ' +  cast(@tempId as varchar(10)) + ' , ' +  cast(@MarketId as varchar(10)) + ' , ' + cast(@ZoneScCounter as varchar(10)) + ' , ' +  @UtilityCode + ' , ' + @Product_Id
							
							-- Insert into lp_common..Common_Product_Rate
								INSERT INTO [lp_common].[dbo].[common_product_rate]
									   ([product_id],[rate_id] ,[eff_date],[rate],[rate_descp],[due_date],[grace_period],[contract_eff_start_date],[val_01],[input_01],[process_01],[val_02],[input_02],[process_02],[service_rate_class_id],[zone_id],[date_created],[username],[inactive_ind],[active_date],[chgstamp],[term_months],[fixed_end_date],[GrossMargin],[IndexType])
								 VALUES
									   (@Product_Id
									   ,@NewRate_Id
									   ,'8/1/2010'
									   ,1
									   ,@ProductDesc
									   ,'8/1/2010'
									   , 365
									   ,'8/1/2010'
									   ,'NONE'
									   ,''
									   ,'NONE'
									   ,'NONE'
									   ,''
									   ,'NONE'
									   ,@ServiceClassId
									   ,@ZoneId
									   ,GETDATE()
									   ,'LIBERTYPOWER\gworthington'
									   ,1
									   ,'8/1/2010'
									   ,0
									   ,Case When @Term <> 0 Then @Term Else @UpperTerm End
									   ,0
									   ,0
									   ,'')
							
							-- Insert into LibertyPower.dbo.product_transition
							INSERT INTO [LibertyPower].[dbo].[product_transition]
								   ([product_id],[rate_id],[MarketID],[UtilityID],[ZoneID],[ServiceClassID],[Term],[AccountTypeID],[ProductTypeID],[ChannelTypeID],[RelativeStartMonth])
							 VALUES
								   (@Product_Id
								   ,@NewRate_Id
								   ,@MarketID
								   ,@UtilityID
								   ,@ZoneID
								   ,@ServiceClassID
								   ,Case When @Term <> 0 Then @Term Else @UpperTerm End
								   ,@SegmentID
								   ,@ProductTypeID
								   ,@ChannelTypeID
								   ,@RelativeMonth)
							
							--Set @ChannelGroupId = @ChannelGroupId -1 
						--End
						Set @RelativeMonth = @RelativeMonth -1
					End
				END
				delete from #ProductTemp
				where @ProductTempId = TempID
				
			End
			
			drop table #ProductTemp
			
			delete from #ProdConfig where tempId = @tempId
		END
	END -- End If
ELSE
 print 'Records already exist for this sales channel'
 
Set NoCount off
drop table #ProdConfig

-- Update any old records that do not have a relative start month
update LibertyPower.dbo.product_transition
set RelativeStartMonth = 0
where RelativeStartMonth is null

-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingAddLegacyRateIdsForNewGroup';

