--ALTER TABLE dbo.UtilityCompany DROP COLUMN UtilityStatus
--GO
--ALTER TABLE dbo.UtilityCompany ADD UtilityStatusId UNIQUEIDENTIFIER NULL
--GO
--ALTER TABLE [dbo].[UtilityCompany]  WITH CHECK ADD  CONSTRAINT [FK_UtilityCompany_TriStateValuePendingActiveInactive] FOREIGN KEY([UtilityStatusId])
--REFERENCES [dbo].[TriStateValuePendingActiveInactive] ([Id])
--GO

--ALTER TABLE [dbo].[UtilityCompany] CHECK CONSTRAINT [FK_UtilityCompany_TriStateValuePendingActiveInactive]
--GO

CREATE PROC usp_UtilityCompany_Detail
	@Id AS UNIQUEIDENTIFIER
AS
BEGIN

	SELECT
		UC.Id,
		UC.UtilityIdInt,
		UC.UtilityCode,
		UC.FullName,
		UC.ParentCompany,
		I.Name ISO,
		UC.IsoId,
		M.Market,
		UC.MarketId,
		M.MarketIdInt,
		UC.PrimaryDunsNumber,
		UC.LpEntityId,
		UC.UtilityStatusId,
		PAI.Value AS UtilityStatus,
		PAI.NumericValue AS UtilityStatusIdInt,
		UC.Inactive,
		UC.CreatedBy,
		UC.CreatedDate,
		UC.LastModifiedBy,
		UC.LastModifiedDate
	FROM	
		dbo.UtilityCompany (NOLOCK) UC
		LEFT OUTER JOIN dbo.ISO (NOLOCK) I
			ON UC.IsoId = I.Id
		LEFT OUTER JOIN dbo.Market (NOLOCK) M
			ON UC.MarketId = M.Id
		LEFT OUTER JOIN dbo.TriStateValuePendingActiveInactive (NOLOCK) PAI
			ON UC.UtilityStatusId = PAI.Id
	WHERE
		UC.Id = @Id

END