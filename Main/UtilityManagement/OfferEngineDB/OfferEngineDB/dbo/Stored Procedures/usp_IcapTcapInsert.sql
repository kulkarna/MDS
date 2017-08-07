
/*******************************************************************************
 * usp_IcapTcapInsert
 * Insert additional Icap and Tcap data for account
 *
 * History
 *******************************************************************************
 * 5/12/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_IcapTcapInsert]
	@UtilityCode			varchar(50),
	@AccountNumber			varchar(50),
	@Icap					decimal(18,9),
	@IcapStartDate			datetime,
	@IcapEndDate			datetime,
	@Tcap					decimal(18,9),
	@TcapStartDate			datetime,
	@TcapEndDate			datetime,
	@IcapPending			decimal(18,9),
	@IcapStartDatePending	datetime,
	@IcapEndDatePending		datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID		int
    
    SELECT	@ID = ID
    FROM	OE_ACCOUNT WITH (NOLOCK)
    WHERE	ACCOUNT_NUMBER	= @AccountNumber
    AND		UTILITY			= @UtilityCode
    
    IF @ID IS NOT NULL
		BEGIN
			-- current Icap  -------------------------------------------------------------
			IF EXISTS (	SELECT	NULL
						FROM	OeIcaps  WITH (NOLOCK)
						WHERE	OeAccountID	= @ID
						AND		StartDate	= @IcapStartDate
						AND		EndDate		= @IcapEndDate )
				BEGIN
					UPDATE	OeIcaps
					SET		Icap		= @Icap,
							[TimeStamp]	= GETDATE()
					WHERE	OeAccountID	= @ID
					AND		StartDate	= @IcapStartDate
					AND		EndDate		= @IcapEndDate					
				END
			ELSE
				BEGIN
					INSERT INTO	OeIcaps (OeAccountID, Icap, StartDate, EndDate, [TimeStamp])
					VALUES		(@ID, @Icap, @IcapStartDate, @IcapEndDate, GETDATE())
				END
				
			-- pending Icap  --------------------------------------------------------------
			IF EXISTS (	SELECT	NULL
						FROM	OeIcaps  WITH (NOLOCK)
						WHERE	OeAccountID	= @ID
						AND		StartDate	= @IcapStartDatePending
						AND		EndDate		= @IcapEndDatePending )
				BEGIN
					UPDATE	OeIcaps
					SET		Icap		= @IcapPending,
							[TimeStamp]	= GETDATE()
					WHERE	OeAccountID	= @ID
					AND		StartDate	= @IcapStartDatePending
					AND		EndDate		= @IcapEndDatePending					
				END
			ELSE
				BEGIN
					INSERT INTO	OeIcaps (OeAccountID, Icap, StartDate, EndDate, [TimeStamp])
					VALUES		(@ID, @IcapPending, @IcapStartDatePending, @IcapEndDatePending, GETDATE())
				END		
				
			-- current Tcap  -------------------------------------------------------------
			IF EXISTS (	SELECT	NULL
						FROM	OeTcaps  WITH (NOLOCK)
						WHERE	OeAccountID	= @ID
						AND		StartDate	= @TcapStartDate
						AND		EndDate		= @TcapEndDate )
				BEGIN
					UPDATE	OeTcaps
					SET		Tcap		= @Tcap,
							[TimeStamp]	= GETDATE()
					WHERE	OeAccountID	= @ID
					AND		StartDate	= @TcapStartDate
					AND		EndDate		= @TcapEndDate					
				END
			ELSE
				BEGIN
					INSERT INTO	OeTcaps (OeAccountID, Tcap, StartDate, EndDate, [TimeStamp])
					VALUES		(@ID, @Tcap, @TcapStartDate, @TcapEndDate, GETDATE())
				END						
		END

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

