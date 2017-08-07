-- =============================================
-- Author:		Rick Deigsler
-- Create date: 9/12/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_price_matrix_ins]

@p_0				datetime,
@p_1				decimal(10,5),
@p_2				decimal(10,5),
@p_3				decimal(10,5),
@p_4				decimal(10,5),
@p_5				decimal(10,5),
@p_6				decimal(10,5),
@p_7				decimal(10,5),
@p_8				decimal(10,5),
@p_9				decimal(10,5),
@p_10				decimal(10,5),
@p_11				decimal(10,5),
@p_12				decimal(10,5),
@p_13				decimal(10,5),
@p_14				decimal(10,5),
@p_15				decimal(10,5),
@p_16				decimal(10,5),
@p_17				decimal(10,5),
@p_18				decimal(10,5),
@p_19				decimal(10,5),
@p_20				decimal(10,5),
@p_21				decimal(10,5),
@p_22				decimal(10,5),
@p_23				decimal(10,5),
@p_24				decimal(10,5),
@p_25				decimal(10,5),
@p_26				decimal(10,5),
@p_27				decimal(10,5),
@p_28				decimal(10,5),
@p_29				decimal(10,5),
@p_30				decimal(10,5),
@p_31				decimal(10,5),
@p_32				decimal(10,5),
@p_33				decimal(10,5),
@p_34				decimal(10,5),
@p_35				decimal(10,5),
@p_36				decimal(10,5),
@p_37				decimal(10,5),
@p_38				decimal(10,5),
@p_39				decimal(10,5),
@p_40				decimal(10,5),
@p_41				decimal(10,5),
@p_42				decimal(10,5),
@p_43				decimal(10,5),
@p_44				decimal(10,5),
@p_45				decimal(10,5),
@p_46				decimal(10,5),
@p_47				decimal(10,5),
@p_48				decimal(10,5),
@p_load_shape_id	varchar(50),
@p_date				datetime,
@p_zone				varchar(50),
@p_retail_mkt_id	varchar(50),
@p_utility_id		varchar(50)

AS

IF EXISTS (	SELECT	NULL
			FROM	OE_PRICE_MATRIX
			WHERE	FLOW_START_DATE	= @p_0
			AND		LOAD_SHAPE_ID	= @p_load_shape_id
			AND		ZONE			= @p_zone
			AND		MARKET			= @p_retail_mkt_id
			AND		UTILITY			= @p_utility_id
			AND		FILE_DATE		= @p_date)
	BEGIN
		UPDATE	OE_PRICE_MATRIX
		SET		[1] = @p_1,[2] = @p_2, [3] = @p_3, [4] = @p_4, [5] = @p_5, 
				[6] = @p_6, [7] = @p_7, [8] = @p_8, [9] = @p_9, [10] = @p_10, 
				[11] = @p_11, [12] = @p_12, [13] = @p_13, [14] = @p_14, [15] = @p_15, 
				[16] = @p_16, [17] = @p_17, [18] = @p_18, [19] = @p_19, [20] = @p_20, 
				[21] = @p_21, [22] = @p_22, [23] = @p_23, [24] = @p_24, [25] = @p_25, 
				[26] = @p_26, [27] = @p_27, [28] = @p_28, [29] = @p_29, [30] = @p_30, 
				[31] = @p_31, [32] = @p_32, [33] = @p_33, [34] = @p_34, [35] = @p_35, 
				[36] = @p_36, [37] = @p_37, [38] = @p_38, [39] = @p_39, [40] = @p_40, 
				[41] = @p_41, [42] = @p_42, [43] = @p_43, [44] = @p_44, [45] = @p_45, 
				[46] = @p_46, [47] = @p_47, [48] = @p_48, LAST_MODIFIED = GETDATE()
		WHERE	FLOW_START_DATE	= @p_0
		AND		LOAD_SHAPE_ID	= @p_load_shape_id
		AND		ZONE			= @p_zone
		AND		MARKET			= @p_retail_mkt_id
		AND		UTILITY			= @p_utility_id
		AND		FILE_DATE		= @p_date
	END
ELSE
	BEGIN
		INSERT INTO OE_PRICE_MATRIX
					(FLOW_START_DATE, [1], [2], [3], [4], [5], [6], [7], [8], [9], 
					[10], [11], [12], [13], [14], [15], [16], [17], [18], [19], 
					[20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], 
					[31], [32], [33], [34], [35], [36], [37], [38], [39], [40], 
					[41], [42], [43], [44], [45], [46], [47], [48], 
					LOAD_SHAPE_ID, ZONE, MARKET, UTILITY, FILE_DATE, LAST_MODIFIED)
		VALUES		(@p_0, @p_1, @p_2, @p_3, @p_4, @p_5, @p_6, @p_7, @p_8, @p_9, 
					@p_10, @p_11, @p_12, @p_13, @p_14, @p_15, @p_16, @p_17, @p_18, @p_19, 
					@p_20, @p_21, @p_22, @p_23, @p_24, @p_25, @p_26, @p_27, @p_28, @p_29, 
					@p_30, @p_31, @p_32, @p_33, @p_34, @p_35, @p_36, @p_37, @p_38, @p_39, @p_40, 
					@p_41, @p_42, @p_43, @p_44, @p_45, @p_46, @p_47, @p_48, 
					@p_load_shape_id, @p_zone, @p_retail_mkt_id, @p_utility_id, @p_date, GETDATE())
	END
