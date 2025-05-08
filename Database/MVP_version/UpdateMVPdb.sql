--=============================================
--	Обновление таблицы Project
--	Добавлено поле ProjectRaiting, а так же проверка
--=============================================

alter table Projects
add column ProjectRating int default 0,
add constraint ProjectRating_Range check(ProjectRating between 0 and 5)