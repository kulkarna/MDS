USE Lp_commissions
GO

INSERT INTO payment_option (
	payment_option_code,
	payment_option_value,
	payment_option_descp,
	active,
	payment_option_type_id,
	date_created,
	username,
	date_modified,
	modified_by
)
VALUES(
	'Advance 50/50',
	0.5,
	'(50/50) Advance 12 100% + 50% Remaining COntract Term',
	1,
	1,
	GETDATE(),
	'lfelican',
	GETDATE(), 
	'lfelican'
)
GO

INSERT INTO payment_option_def(
	payment_option_def_code,
	payment_option_def_descp,
	payment_type_id,
	payment_term,
	is_term_fixed,
	active,
	date_created,
	username,
	date_modified,
	modified_by
)
VALUES(
	'Prepaid50-50%',
	'100% first 12 Contract Term + 50% Contract Term Prepaid/Advance Payment.',
	2,
	.5,
	0,
	1,
	GETDATE(),
	'lfelican',
	GETDATE(),
	'lfelican'
)
GO

INSERT INTO payment_option_setting(
	payment_option_id,
	payment_option_param_id,
	payment_option_param_value,
	payment_option_def_id,
	calculation_freq_id,
	payment_freq_id,
	active,
	priority,
	date_created,
	username,
	date_modified,
	modified_by
)
VALUES(
	29,
	0,
	NULL,
	12,
	0,
	0,
	1,
	0,
	GETDATE(),
	'lfelican',
	GETDATE(),
	'lfelican'
)
GO