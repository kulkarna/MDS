/*******************************************************************************
 * usp_DailyPricingAddLegacyRateIdsForMissingProducts
 *
 *
 ******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingAddLegacyRateIdsForMissingProducts]  
	@Market			int        -- from libertypower..market
	,@Utility		int = null -- from libertypower..utility
	,@Segment		int = null -- account type i.e. SMP, RES, ETC ID ID from libertypower.dbo.AccountType
	,@ProductType	int = null -- FIXED,INDEX  from libertypower..ProductType
	,@Zone			int = null -- The ID from lp_common..zone
	,@ServiceClass	int = null -- The ID from lp_common..service_rate_class
	,@ChannelType	int = null -- ABC OR TELESALES from libertypower..channeltype
	
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
Join libertypower.dbo.utility u (NOLOCK)on pc.utilityId = u.Id
WHERE pc.MarketID = @Market
	AND pc.UtilityID = COALESCE(@Utility, pc.UtilityID)
	AND pc.ZoneID =  COALESCE(@Zone, pc.ZoneID)
	AND pc.ServiceClassID = COALESCE(@ServiceClass, pc.ServiceClassID)
	AND pc.ChannelTypeID = COALESCE(@ChannelType, pc.ChannelTypeID)
	AND pc.SegmentID =  COALESCE(@Segment, pc.SegmentID)
	AND pc.ProductTypeId = COALESCE(@ProductType, pc.ProductTypeId)
--	AND pc.ProductConfigurationID > 1925 -- don't load older configs
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
		
Select @ChannelGroupIdMax= Max(ChannelGroupID) from LibertyPower.dbo.ChannelGroup		
Set @previousZone = 0
Set @previousSC = 0
set @ZoneScCounter = 1

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
						OR	(account_type_id=2 AND @SegmentID = 3)
						OR	(account_type_id=4 AND @SegmentID = 4)) -- SOHO
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
									While @ChannelGroupId > 3 -- 4 is the smallest channel group ID
										Begin
											Set @NewRate_Id = ISNULL(@ZoneScCounter, 1)								--        1
											If @IsTermRange	= 0									
												Set @NewRate_Id = @Term * 100 + @NewRate_Id								--      301
											Else
												Set @NewRate_Id = @UpperTerm * 100 + @NewRate_Id
											Set @NewRate_Id = @RelativeMonth * 10000 + @NewRate_Id						--    60301
											Set @NewRate_Id = @ChannelGroupId * 1000000 + @NewRate_Id					--  1060301
											Set @NewRate_Id = 100000000 + @NewRate_Id									--101060301	
											
											-- Loop through until you find the next available increment.
											While ((Select count(product_id) From lp_common..Common_Product_Rate WITH (NOLOCK) Where product_id = @Product_Id AND rate_id = @NewRate_Id) > 0)
												OR ((Select count(product_id) From libertypower..product_transition WITH (NOLOCK) Where product_id = @Product_Id AND rate_id = @NewRate_Id) > 0)
												Begin
													--print 'duplicate *****************************************************************'
													Set @NewRate_Id = @NewRate_Id + 1
													Set @ZoneScCounter = @NewRate_Id % 100
												End
												
											
											declare @zoneCode varchar(50), @ScCode varchar(50)
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
												
						--print rtrim(cast(@Product_Id as varchar(25))) + '|' + cast(@NewRate_Id as varchar(10)) + ' , ' +  @ProductDesc + ' , ' + ' , ' + cast(@Term as varchar(10)) + ' , ' +  cast(@tempId as varchar(10)) + ' , ' +  cast(@MarketId as varchar(10)) + ' , ' + cast(@ZoneScCounter as varchar(10)) + ' , ' +  @UtilityCode + ' , ' + @Product_Id
						
						--PRINT 'Market ID ' + str(@MarketID, 2) + ' | Utility ID ' + str(@UtilityID, 2) + ' | Zone ID ' + str(@ZoneID, 3) + ' | Service Class ID ' + str(@ServiceClassID, 3) + ' | Term ' + str(@Term, 2) + ' | Segment ID ' + str(@SegmentID, 2) + ' | Product Type ID ' + str(@ProductTypeID, 2) + ' | Channel Type ID ' + str(@ChannelTypeID, 2) + ' | Relative Month ' + str(@RelativeMonth, 2) + ' | Rate ID LIKE ' + '1' + REPLACE(STR(@ChannelGroupId, 2), SPACE(1), '0')
						--PRINT ' '
--if @Product_Id like 'PENNPR%'
--	begin
--		print '@Product_Id ' + cast(@Product_Id as varchar(25))
--		print '@MarketID ' + cast(@MarketID as varchar(25))
--		print '@UtilityID ' + cast(@UtilityID as varchar(25))
--		print '@ZoneID ' + cast(@ZoneID as varchar(25))
--		print '@ServiceClassID ' + cast(@ServiceClassID as varchar(25))
--		print '@Term ' + cast(@Term as varchar(25))
--		print '@LowerTerm ' + cast(isnull(@LowerTerm, 0) as varchar(25))
--		print '@UpperTerm ' + cast(isnull(@UpperTerm, 0) as varchar(25))
--		print '@SegmentID ' + cast(@SegmentID as varchar(25))
--		print '@ProductTypeID ' + cast(@ProductTypeID as varchar(25))
--		print '@ChannelTypeID ' + cast(@ChannelTypeID as varchar(25))
--		print '@RelativeMonth ' + cast(@RelativeMonth as varchar(25))
--		print '@@ChannelGroupId ' + cast(@ChannelGroupId as varchar(25))
--	end
											-- Before inserting this record, make sure that it doesn't already exist.
											IF Not Exists(
														Select top 1 *  From [LibertyPower].[dbo].[product_transition] (NOLOCK)
														Where [product_id] = 	@Product_Id
														AND [MarketID] =@MarketID
														And [UtilityID] =@UtilityID
														and [ZoneID] =@ZoneID
														and [ServiceClassID] =@ServiceClassID
														--and [Term] = Case When @Term <> 0 Then @Term Else @UpperTerm End
														and ((@Term <> 0 AND [Term] = @Term)
															OR (@Term = 0 AND [Term] between @LowerTerm and @UpperTerm))
														and [AccountTypeID] =@SegmentID
														and [ProductTypeID] =@ProductTypeID
														and [ChannelTypeID] =@ChannelTypeID
														and [RelativeStartMonth] =@RelativeMonth
														and [rate_id] like '1' + REPLACE(STR(@ChannelGroupId, 2), SPACE(1), '0') + '%'
														)
											--AND @NewRate_Id IS NOT NULL
											Begin
												PRINT ' '
												PRINT	'************************************   INSERTED   *********************************************'
												PRINT	'Product ID ' + rtrim(cast(@Product_Id as varchar(25))) + ' ::: Rate ID ' + cast(@NewRate_Id as varchar(25)) + ' ::: Market ID ' + str(@MarketID, 2) + ' ::: Utility ID ' + str(@UtilityID, 2) + ' ::: Zone ID ' + str(@ZoneID, 3) + ' ::: Service Class ID ' + str(@ServiceClassID, 3) + ' ::: Term ' + str(@Term, 2) + ' ::: Segment ID ' + str(@SegmentID, 2) + ' ::: Product Type ID ' + str(@ProductTypeID, 2) + ' ::: Channel Type ID ' + str(@ChannelTypeID, 2) + ' ::: Relative Month ' + str(@RelativeMonth, 2)
												PRINT ' '
											
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
													   ,'SYSTEM'
													   ,1
													   ,'8/1/2010'
													   ,0
													   ,Case When @Term <> 0 Then @Term Else @UpperTerm End
													   ,0
													   ,0
													   ,'')
											
											BEGIN TRY
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
											END TRY
											BEGIN CATCH
												DECLARE	@ErrorMessage	varchar(2000),
														@ErrorParams	varchar(2000)
												SET		@ErrorMessage	= ERROR_MESSAGE()
												SET		@ErrorParams	= '::: Error Parameters ::: Market ID ' + str(@MarketID, 2) + ' ::: Utility ID ' + str(@UtilityID, 2) + ' ::: Zone ID ' + str(@ZoneID, 3) + ' ::: Service Class ID ' + str(@ServiceClassID, 3) + ' ::: Term ' + str(@Term, 2) + ' ::: Segment ID ' + str(@SegmentID, 2) + ' ::: Product Type ID ' + str(@ProductTypeID, 2) + ' ::: Channel Type ID ' + str(@ChannelTypeID, 2) + ' ::: Relative Month ' + str(@RelativeMonth, 2)
												 PRINT ' '
												 PRINT @ErrorMessage
												 PRINT @ErrorParams
												 PRINT ' '
												 SET	@ErrorMessage = @ErrorMessage + '<br><br>' + @ErrorParams
												 
												 EXEC usp_DailyPricingLogInsert_New @MessageType = 2, @DailyPricingModule = 3, @Message = @ErrorMessage, @StackTrace = NULL, @CreatedBy = 0
											END CATCH

											END		-- Ends If record already exists.					
											Set @ChannelGroupId = @ChannelGroupId -1 
										End -- Ends While @ChannelGroupId > 0
									Set @RelativeMonth = @RelativeMonth -1
								End  -- Ends @RelativeMonth > 0
						END -- Ends IF (@CreateRateId = 1)
						
					delete from #ProductTemp
					where @ProductTempId = TempID
					
				End -- Ends While (select count(*) from #ProductTemp) > 0
			
			drop table #ProductTemp
			
			delete from #ProdConfig where tempId = @tempId
		END
	
 
Set NoCount off
drop table #ProdConfig

-- Update any old records that do not have a relative start month
update LibertyPower.dbo.product_transition
set RelativeStartMonth = 0
where RelativeStartMonth is null


	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingAddLegacyRateIdsForMissingProducts';

