UPDATE	Libertypower..AccountEventHistory
SET		ProductTypeID = z.ProductTypeID
FROM	Libertypower..AccountEventHistory h
		INNER JOIN
(
	SELECT	b.ProductTypeID, h.ID
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN lp_common..common_product p WITH (NOLOCK)
			ON b.ProductBrandID = p.ProductBrandID
			INNER JOIN Libertypower..AccountEventHistory h WITH (NOLOCK)
			ON p.product_id = h.ProductID
)z ON h.ID = z.ID		