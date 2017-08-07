
CREATE PROCEDURE [dbo].[usp_VRE_PorSelect]
	@ContextDate	DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

  SELECT
          ID, Utility, ServiceClassID , PorType , PorRate, FileContextGuid, CreatedBy, DateCreated
      FROM
          VREPorDataCurve WITH ( NOLOCK )
      WHERE
      ID IN ( SELECT MAX(ID)
			FROM	VREPorDataCurve WITH ( NOLOCK )
			WHERE (@ContextDate IS NULL OR VREPorDataCurve.DateCreated < @ContextDate)
			GROUP BY Utility, ServiceClassID)

      SET NOCOUNT OFF ;
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PorSelect';

