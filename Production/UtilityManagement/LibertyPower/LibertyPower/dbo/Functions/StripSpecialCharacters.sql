
CREATE FUNCTION [dbo].[StripSpecialCharacters]
(
	@p_original_string varchar(500)
)

RETURNS varchar(500)

AS

BEGIN
	DECLARE @w_stripped_string	varchar(100)

	--Fix lower case Special Characters
	SET	@w_stripped_string	=	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(@p_original_string, 'à', 'a') , 'á', 'a') , 'â', 'a') , 'ã', 'a')
								, 'ä', 'a') , 'è', 'e') , 'é', 'e') , 'ê', 'e') , 'ë', 'e') , 'ì', 'i')
								, 'í', 'i') , 'î', 'i') , 'ï', 'i') , 'ñ', 'n') , 'ò', 'o') , 'ó', 'o')
								, 'ô', 'o') , 'õ', 'o') , 'ö', 'o') , 'ù', 'u') , 'ú', 'u') , 'û', 'u')
								, 'ü', 'u') , 'ý', 'y') , 'š', 's') , 'ž', 'z') , '~', ' ')

	--Fix UPPER CASE Special Characters
	SET	@w_stripped_string	=	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								REPLACE(@w_stripped_string, 'À', 'A') , 'Á', 'A') , 'Â', 'A') , 'Ã', 'A')
								, 'Ä', 'A') , 'È', 'E') , 'É', 'E') , 'Ê', 'E') , 'Ë', 'E') , 'Ì', 'I')
								, 'Í', 'I') , 'Î', 'I') , 'Ï', 'I') , 'Ñ', 'N') , 'Ò', 'O') , 'Ó', 'O')
								, 'Ô', 'O') , 'Õ', 'O') , 'Ö', 'O') , 'Ù', 'U') , 'Ú', 'U') , 'Û', 'U')
								, 'Ü', 'U') , 'Ý', 'Y') , 'Š', 'S') , 'Ž', 'Z')

	--RETURN UPPER(@w_stripped_string)		--REMOVED: Please change capitalization as necessary in UI, stored procs, or downstream code.
	RETURN @w_stripped_string
END



