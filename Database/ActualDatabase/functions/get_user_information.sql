create function get_user_information
(
	p_userid bigint
)
returns table
(
	User_ID bigserial,
	User_Name text,
	User_surname text,
	User_MiddleName text,
	User_Alias text,
	User_Age int,
	User_Avatar text,
	User_Bio text,
	User_Country text,
	User_Town text,
	User_specialization text,
	User_Phone text,
	User_Email text,
	User_CreatedAt timestamp,
	User_IsDeleted boolean,
	User_Password text,
	Team_Name text,
	Projects
)
language plpgsql
as $$
	begin
	Return Query
		select