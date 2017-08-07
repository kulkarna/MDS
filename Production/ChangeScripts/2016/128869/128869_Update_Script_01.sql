Use [LP_UTILITYMANAGEMENT]
GO

DELETE K
FROM NameKeyPattern K
INNER JOIN (
	SELECT A.UtilityCompanyId
	FROM LP_UTILITYMANAGEMENT..NAMEKEYPATTERN A
	left JOIN Lp_UtilityManagement..UtilityCompany B ON A.UtilityCompanyId = B.Id
	WHERE UTILITYCODE IN (
			'CL&P'
			,'DAYTON'
			,'MECO'
			,'NANT'
			,'NECO'
			,'UI'
			,'UNITIL'
			,'WMECO'
			,'NSTAR-BOS'
			,'NSTAR-COMM'
			,'NSTAR-CAMB'
			)
	GROUP BY A.UtilityCompanyId
	HAVING COUNT(1) > 1
	) M ON K.UtilityCompanyId = M.UtilityCompanyId

INSERT INTO [DBO].[NAMEKEYPATTERN] (
	[ID]
	,[UTILITYCOMPANYID]
	,[NAMEKEYPATTERN]
	,[NAMEKEYPATTERNDESCRIPTION]
	,[NAMEKEYADDLEADINGZERO]
	,[NAMEKEYTRUNCATELAST]
	,[NAMEKEYREQUIREDFOREDIREQUEST]
	,[INACTIVE]
	,[CREATEDBY]
	,[CREATEDDATE]
	,[LASTMODIFIEDBY]
	,[LASTMODIFIEDDATE]
	)
SELECT NEWID() as [ID]
	,B.ID as UTILITYCOMPANYID
	,N'^[a-zA-Z0-9\s]{4}$' [NAMEKEYPATTERN]
	,N'4 LETTER NAME KEY' [NAMEKEYPATTERNDESCRIPTION]
	,NULL [NAMEKEYADDLEADINGZERO]
	,NULL [NAMEKEYTRUNCATELAST]
	,1[INACTIVE]
	,0 [NAMEKEYREQUIREDFOREDIREQUEST]
	,N'VSHARMA' [CREATEDBY]
	,GETDATE()  [CREATEDDATE]
	,N'VSHARMA' [LASTMODIFIEDBY]
	,GETDATE()   [LASTMODIFIEDDATE]
FROM LP_UTILITYMANAGEMENT..NAMEKEYPATTERN(NOLOCK) A
RIGHT OUTER JOIN LP_UTILITYMANAGEMENT..UTILITYCOMPANY(NOLOCK) B ON A.UTILITYCOMPANYID = B.ID
WHERE UTILITYCODE IN (
		'CL&P'
		,'DAYTON'
		,'MECO'
		,'NANT'
		,'NECO'
		,'UI'
		,'UNITIL'
		,'WMECO'
		,'NSTAR-BOS'
		,'NSTAR-COMM'
		,'NSTAR-CAMB'
		)
	AND A.UTILITYCOMPANYID IS NULL
	--AND A.INACTIVE = 0

UPDATE A
SET A.NAMEKEYPATTERN = N'^[a-zA-Z0-9\s]{4}$'
	,A.NAMEKEYPATTERNDESCRIPTION = N'4 LETTER NAME KEY'
	,A.LASTMODIFIEDBY = N'VSHARMA'
	,A.LASTMODIFIEDDATE = GETDATE()
FROM LP_UTILITYMANAGEMENT..NAMEKEYPATTERN(NOLOCK) A
INNER JOIN LP_UTILITYMANAGEMENT..UTILITYCOMPANY(NOLOCK) B ON A.UTILITYCOMPANYID = B.ID
WHERE UTILITYCODE IN (
		'CL&P'
		,'DAYTON'
		,'MECO'
		,'NANT'
		,'NECO'
		,'UI'
		,'UNITIL'
		,'WMECO'
		,'NSTAR-BOS'
		,'NSTAR-COMM'
		,'NSTAR-CAMB'
		)
	AND A.INACTIVE = 0
