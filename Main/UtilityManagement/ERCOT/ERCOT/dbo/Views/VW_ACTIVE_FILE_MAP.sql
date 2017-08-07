--------------------------------------------------------------------------------
--
--	View name:		VW_ACTIVE_FILE_MAP
--	Written by:		Alberto Franco
--	Date written:	10/19/2007
--	Project:		ERCOT Extract
--
--------------------------------------------------------------------------------
--
--	This view is consumed by the SSIS package named "ERCOT Extract" 
--	and specifically relates to the processing of zip files dropped in 
--	the drop folder.
--
--	Business requirements indicate that dropped zip files should be 
--	processed in a sequential manner based on a counter found in the 
--	zip filename. This is true only when the sequence flag is set.
--
--	This view retrieves the ENTITY_ID, the IS_SEQUENTIAL, the 
--	LAST_SEQUENCE_NUM and the COUNT_FILE_PATTERN properties of each file type 
--	identified by its FILE_NAME_LOOKUP.
--
--	The COUNT_FILE_PATTERN is a regular expression that allows the
--	retrieval of the zip file counter to ensure that files are 
--	processed in a sequential manner as they are retrieved from ERCOT.
--
--	The LAST_SEQUENCE_NUM indicates the zip file that was last 
--	processed for a particular file type.
--
--	The IS_SEQUENTIAL column value indicates whether the business requirement 
--	indicating that zip files should be processed in order of their operating 
--	date should be enforced or not.
--
--	When IS_SEQUENTIAL = 1 then the process may only process files with an 
--	operating date following the LAST_OPERATING_DATE for a particular file type.
--
--	When IS_SEQUENTIAL = 0 then the process may proceed in importing any zip 
--	file not constrained by its operating date value.
--
--	Initially, when no processing log appears for a particular file type,
--	the IS_SEQUENTIAL value will return a value of 0 indicating that any
--	operating date is valid for that particular file type.
--
--------------------------------------------------------------------------------
CREATE VIEW [dbo].[VW_ACTIVE_FILE_MAP]
AS
	WITH LAST_FILE_DROPPED (FILE_MAP_ID, LAST_SEQUENCE_NUM) AS
	(
	SELECT FILE_MAP_ID, MAX(SEQUENCE_NUM) AS LAST_SEQUENCE_NUM
	FROM LOG_FILE_DROPPED
	WHERE SUCCESS = 1
	GROUP BY FILE_MAP_ID
	)
	SELECT
		A.FILE_NAME_LOOKUP,
		A.ENTITY_ID,
		CASE WHEN B.LAST_SEQUENCE_NUM IS NULL THEN CAST(0 AS BIT) ELSE A.IS_SEQUENTIAL END AS IS_SEQUENTIAL,
		ISNULL(B.LAST_SEQUENCE_NUM, 0) AS LAST_SEQUENCE_NUM,
		A.COUNT_FILE_PATTERN,
		A.FILE_HAS_DATE,
		A.DATE_REGEX,
		A.DATE_FORMAT
	FROM
		USAGE_FILE_MAP A
	LEFT JOIN
		LAST_FILE_DROPPED B ON A.ROW_ID = B.FILE_MAP_ID
	WHERE
		(A.DISABLED = 0)
