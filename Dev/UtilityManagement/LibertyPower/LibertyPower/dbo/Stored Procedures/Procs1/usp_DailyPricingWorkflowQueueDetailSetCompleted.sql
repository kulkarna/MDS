/*******************************************************************************
 * usp_DailyPricingWorkflowQueueDetailSetCompleted
 * Sets detail record to complete with time stamp
 *
 * History
 *******************************************************************************
 * 2/23/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingWorkflowQueueDetailSetCompleted]
	@Identity		int,
	@Status			tinyint,
	@DateCompleted	datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProcessId	int
    
	SELECT	@ProcessId = ProcessId
	FROM	DailyPricingWorkflowQueueDetail WITH (NOLOCK)
	WHERE	ID = @Identity 		
    
    UPDATE	DailyPricingWorkflowQueueDetail
    SET		Status			= @Status,
			DateCompleted	= @DateCompleted
	WHERE	ID				= @Identity
	
	IF @ProcessId = 0 -- only execute on cost rate upload completion
		BEGIN
			-- activates channel groups that have at least one channel assigned to the group
			update libertypower..channelgroup
			set active = 1
			where channelgroupid in
			(
				-- gets channel group ids that have at least one channel assigned to the group
				select channelgroupid
				from libertypower..channelgroup
				where channelgroupid in
				(
					select distinct cg.channelgroupid
					from libertypower..saleschannelchannelgroup cg
					join libertypower..saleschannel sc on sc.channelid = cg.channelid
					join
					(
						select max(saleschannelchannelgroupid) as saleschannelchannelgroupid, channelname
						from libertypower..saleschannelchannelgroup cg
						join libertypower..saleschannel sc on sc.channelid = cg.channelid
						group by channelname
					) m on cg.saleschannelchannelgroupid = m.saleschannelchannelgroupid
					where sc.inactive = 0
				)
				and active = 0
			)	
			
			-- inactivates channel groups that do not have at least one channel assigned to the group
			update libertypower..channelgroup
			set active = 0
			where channelgroupid in
			(
				-- gets channel group ids that do not have at least one channel assigned to the group
				select channelgroupid
				from libertypower..channelgroup
				where channelgroupid not in
				(
					select distinct cg.channelgroupid
					from libertypower..saleschannelchannelgroup cg
					join libertypower..saleschannel sc on sc.channelid = cg.channelid
					join
					(
						select max(saleschannelchannelgroupid) as saleschannelchannelgroupid, channelname
						from libertypower..saleschannelchannelgroup cg
						join libertypower..saleschannel sc on sc.channelid = cg.channelid
						group by channelname
					) m on cg.saleschannelchannelgroupid = m.saleschannelchannelgroupid
					where sc.inactive = 0
				)
				and active = 1
			)
	END	
	
	-- reindex for performance  
	--IF	@ProcessId = 3 
	--	BEGIN
	--		DBCC	DBREINDEX('ProductCrossPrice',' ',90)	-- product cross prices
	--		DBCC	DBREINDEX('Price',' ',90)				-- sales channel prices
	--	END  	
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
