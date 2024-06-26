with 
dm_table_data_web_users as (
      select * from  {{ source('dm_table_data', 'WEB_USER') }}
), 

dm_table_data_commcare_user as (
      select * from  {{ source('dm_table_data', 'CASE_COMMCARE_USER') }}
), 
 
tableau_users_fixture as 
(

     select email, 'HQ/' || username as username from dm_table_data_web_users

),


recent_user as
    (
        select max(date_opened) max_date, email from dm_table_data_commcare_user group by email
    ),

user_access as(


select ccu.email, tuf.username, 
case when ccu.commcare_location_ids is null
then ('All') 
else ('None')
end as security_access from dm_table_data_commcare_user ccu inner join recent_user rc on ccu.email = rc.email and ccu.date_opened = rc.max_date
    inner join tableau_users_fixture tuf on upper(tuf.email) = upper(ccu.email)),


final as (
select * 

    
from user_access
)


select 
	EMAIL,
	USERNAME,
	SECURITY_ACCESS
from final