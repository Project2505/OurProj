--=================================================
-- Автор: Богданов Д.М.
-- Описание:
-- 		Процедура для регистрации пользователя
--
-- Пример вызова:
--	CALL user_registration
-- 	(
--  'Иван',
--  'Петров',
--  'Сергеевич',
--  'ivan_petrov',
--  25,
--  'https://example.com/avatars/ivan.jpg',
--  'Разработчик ПО и любитель путешествий',
--  'Россия',
--  'Москва',
--  'Backend Developer',
--  '+79161234567',
--  'ivan.petrov@example.com',
--  NULL,
--  'securePassword123!'
--	);
--=================================================

create or replace procedure user_registration
(
    p_username text,
    p_usersurname text,
    p_usermiddlename text,
    p_useralias text,
    p_userage int,
    p_useravatar text,
    p_userbio text,
    p_usercountry text,
    p_usertown text,
    p_userspecialization text,
    p_userphone text,
    p_useremail text,
    p_usercreatedat timestamp,
    p_userpassword text
)
language plpgsql
as $$
begin
    -- проверка обязательных полей
    if p_username is null or p_username = '' then
        raise exception 'имя пользователя не может быть пустым';
    end if;
    
    if p_usersurname is null or p_usersurname = '' then
        raise exception 'фамилия пользователя не может быть пустой';
    end if;
    
    if p_useralias is null or p_useralias = '' then
        raise exception 'псевдоним пользователя не может быть пустым';
    end if;
    
    if p_userage is null then
        raise exception 'возраст пользователя не может быть пустым';
    elsif p_userage < 0 then
        raise exception 'возраст пользователя не может быть отрицательным';
    end if;
    
    if p_usercountry is null or p_usercountry = '' then
        raise exception 'страна пользователя не может быть пустой';
    end if;
    
    if p_usertown is null or p_usertown = '' then
        raise exception 'город пользователя не может быть пустым';
    end if;
    
    if p_userpassword is null or p_userpassword = '' then
        raise exception 'пароль пользователя не может быть пустым';
    end if;
    
    -- вставка данных пользователя
    insert into users (
        username,
        usersurname,
        usermiddlename,
        useralias,
        userage,
        useravatar,
        userbio,
        usercountry,
        usertown,
        userspecialization,
        userphone,
        useremail,
        usercreatedat,
        userpassword
    ) values (
        p_username,
        p_usersurname,
        p_usermiddlename,
        p_useralias,
        p_userage,
        p_useravatar,
        p_userbio,
        p_usercountry,
        p_usertown,
        p_userspecialization,
        p_userphone,
        p_useremail,
        coalesce(p_usercreatedat, now()),
        p_userpassword
    );
    
    commit;
end;
$$;