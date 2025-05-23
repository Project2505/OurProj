--======================================================================================
-- Автор:
--     Богданов Д.М.
--
-- Описание:
--     функция для авторизации пользователей
--     в системе SquadUp
--
-- Дата создания:
--     11.05.2025    
--
-- Пример вызова:
--     select UserAuthorization('user@example.com', null, 'password123');
--
-- Изменения:
--======================================================================================

create or replace function UserAuthorization(
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
    r_email boolean := false;
    r_phone boolean := false;
    r_password boolean := false;
begin
    if (p_email is null) and (p_phone is null) then
        raise exception 'Введите телефон или почту';
    end if;

    if p_password is null then
        raise exception 'Введите пароль';
    end if;

    -- проверка почты
    if p_email is not null then
        select UserEmail into v_email
        from Users 
        where Users.UserEmail = p_email;
    
        if v_email is null or v_email = '' then
            raise exception 'Логин с такой почтой не найден';
        else 
            r_email := true;
        end if;
    end if;

    -- проверка телефона
    if p_phone is not null then
        select UserPhone into v_phone
        from Users 
        where Users.UserPhone = p_phone;
    
        if v_phone is null or v_phone = '' then
            raise exception 'Логин с таким телефоном не найден';
        else 
            r_phone := true;
        end if;
    end if;

    -- проверка пароля
    select UserPassword into v_password
    from Users 
    where (p_email is not null and Users.UserEmail = p_email)
       or (p_phone is not null and Users.UserPhone = p_phone);
    
    if v_password is null or v_password = '' then
        raise exception 'Неверный пароль';
    else 
        if v_password = p_password then
            r_password := true;
        else
            raise exception 'Неверный пароль';
        end if;
    end if;

    -- Проверка комбинаций логина и пароля
    if (r_email and r_password) or (r_phone and r_password) then
        return true;
    else
        raise exception 'Неправильный логин или пароль';
    end if;
    
exception 
    when others then
        raise;
end;
$$;