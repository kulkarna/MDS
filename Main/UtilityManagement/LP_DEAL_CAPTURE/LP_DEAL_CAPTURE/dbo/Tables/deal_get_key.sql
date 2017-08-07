CREATE TABLE [dbo].[deal_get_key] (
    [process_id]  VARCHAR (20) NOT NULL,
    [start_date]  DATETIME     NOT NULL,
    [last_number] NUMERIC (18) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [deal_get_key_idx]
    ON [dbo].[deal_get_key]([process_id] ASC) WITH (ALLOW_PAGE_LOCKS = OFF);

