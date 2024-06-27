select 'Current user:', USER
from dual;

--check system privileges linked to user
select * from USER_SYS_PRIVS;

--check object privileges linked to user
select * from USER_TAB_PRIVS;

--check ROLE priveleges linked to user
select * from USER_ROLE_PRIVS;

--check System privileges linked to the role
select * from ROLE_SYS_PRIVS
;

--check object privileges linked to role
select * from ROLE_TAB_PRIVS;

--check if view is available
select *
from UV_TOPMEASUREMENTCOST;

