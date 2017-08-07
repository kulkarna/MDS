-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates or updates a regulatory authority
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintRegulatoryAuthorityCreateOrUpdate]
	@RegulatoryAuthorityID int,
	@Name varchar(255),
	@MarketCode char(2),
	@RequiredDaysForResolution int,
	@CalendarType varchar(10)
AS
BEGIN

	IF @RegulatoryAuthorityID > 0
		UPDATE ComplaintRegulatoryAuthority SET
			Name = @Name,
			MarketCode = @MarketCode,
			RequiredDaysForResolution = @RequiredDaysForResolution,
			CalendarType = @CalendarType
		WHERE ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID
	ELSE
		BEGIN
			INSERT INTO ComplaintRegulatoryAuthority(Name, MarketCode, RequiredDaysForResolution, CalendarType)
			VALUES (@Name, @MarketCode, @RequiredDaysForResolution, @CalendarType)
			
			SET @RegulatoryAuthorityID = SCOPE_IDENTITY()
		END
		
	SELECT @RegulatoryAuthorityID As RegulatoryAuthorityID

END
