
CREATE PROCEDURE [dbo].[usp_zip_to_zone_lookup_sel]

@utility	varchar(10),
@zip_code	varchar(15)

AS

SELECT		z.zip_code,z.zone				
FROM		zip_to_zone z
WHERE		z.utility = @utility
AND			z.zip_code = @zip_code
