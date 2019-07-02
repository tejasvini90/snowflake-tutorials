create or replace database sf_tuts;
use database sf_tuts;

create or replace table emp_basic (
  first_name string ,
  last_name string ,
  email string ,
  streetaddress string ,
  city string ,
  start_date date
  );
  
create or replace warehouse sf_tuts_wh with
  warehouse_size='X-SMALL'
  auto_suspend = 180
  auto_resume = true
  initially_suspended=true;

use warehouse sf_tuts_wh;

put file:///tejasvini/collabera/snowflake-tutorials/dataset/employees0*.csv @demo_db.public.%emp_basic;


copy into emp_basic
  from @%emp_basic
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees0[1-5].csv.gz'
  on_error = 'skip_file';

create or replace function fn()
returns table (email  string,city string)
as
$$
  select email ,city from emp_basic 
$$
;select * from table(fn())

