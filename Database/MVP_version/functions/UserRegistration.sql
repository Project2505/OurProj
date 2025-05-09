
create procedure UserRegistration
(
	p_UserName text,
    p_UserSurname text,
    p_UserAlias text,
    p_UserAge int,
    p_UserCountry text,
    p_UserTown text,
    p_UserSpecialization text,
    p_UserMiddleName text default null,
    p_UserPhone text default null,
    p_UserEmail text default null
)

Language plpgsql
	as $$
		declare
			v_userID int;
			v_AliasExists int;
		begin
			if p_UserName is null or p_UserSurname is null or 
       p_UserAlias is null or p_UserAge is null or 
       p_UserCountry is null or p_UserTown is null or 
       p_UserSpecialization is null THENl
			   Then raise exception 'Обязательные поля не должны быть пустыми';
		end if;

		select count(*) into v_AliasExists
		from Users
		where UserAlias = p_UserAlias;

		if p_UserAge < 14 or p_UserAge > 120 then
			raise exception 'Недопустимый возраст. Допустимый диапазон: 14-120';
		end if;

		insert into Users
		(
			UserName,
        	UserSurname,
        	UserMiddleName,
        	UserAlias,
        	UserAge,
        	UserCountry,
        	UserTown,
        	UserSpecialization,
        	UserPhone,
        	UserEmail,
        	UserCreatedAt
		)
		Values
		(
			p_UserName,
        	p_UserSurname,
        	p_UserMiddleName,
        	p_UserAlias,
        	p_UserAge,
        	p_UserCountry,
        	p_UserTown,
        	p_UserSpecialization,
        	p_UserPhone,
        	p_UserEmail,
        	NOW()
    ) returning UserID into v_UserID;
		
			commit;
	raise notice 'Пользователь % успешно зарегистрирован с ID %', p_UserAlias, v_UserID;
exception
    when others then
        rollback;
        raise exception 'Ошибка при регистрации пользователя: %', SQLERRM;
end;
$$;