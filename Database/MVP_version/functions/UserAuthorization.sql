create function UserAuthorization
(
	p_email text,
	p_phone text,
	p_password text
)
language plpgsql
as $$ 
	declare v_email text,
	declare v_phone text,
	declare v_password text
begin

	if (p_email is null) and (p_phone is null)
	
	
	