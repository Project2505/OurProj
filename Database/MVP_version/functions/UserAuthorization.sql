--======================================================================================
-- Автор:
--		Богданов Д.М.
--
-- Описание:
--		функция для авторизации пользователей
--		в системе SquadUp
--
-- Дата создания:
--		11.05.2025	
--
-- Пример вызова:
--		
--
-- Изменения:
--======================================================================================

create function UserAuthorization
(
	p_email text,
	p_phone text,
	p_password text
)
returns boolean
language plpgsql
as $$ 
	declare 
	 v_email text;
	 v_phone text;
	 v_password text;
	 r_email boolean;
	 r_phone boolean;
	 r_password boolean;
begin

	if (p_email is null) and (p_phone is null) then
		raise exception 'Введите телефон или почту'
	end if;

	if p_password is null then
		raise exception 'Введите пароль'
	end if;

-- проверка почты
	if p_email is not null then
		select UserEmail into v_email
		from Users 
		where Users.UserEmail = p_email
	
		if v_email is null or '' then
			raise exception 'Логин с такой почтой не найден'
		else 
			set r_email := true
		end if;
	end if

-- проверка телефона
	if p_phone is not null then
		select UserPhone into v_phone
		from Users 
		where Users.UserPhone = p_phone
	
		if v_phone is null or '' then
			raise exception 'Логин с таким телефоном не найден'
		else 
			set r_phone := true
		end if;
	end if;

-- проверка пароля
	select UserPassword into v_password
	from Users 
	where Users.UserPassword = p_password
	
	if v_password is null or '' then
		raise exception 'Логин с такой почтой не найден'
	else 
		set r_password := true
	end if;

	if r_email != true and r_phone != true and r_password != true then
		raise exception 'Неправильный логин или пароль'
	else 
		if (r_email != true and r_password = true) or (r_email = true and r_password != true) or
		(r_phone != true and r_password != true) or (r_phone = true or r_password != true) then
			raise exception 'Неправильный логин или пароль'
		end if;
	end if;

		return true;
	exception 
		when others then
			raise;
	
end;
$$;

	