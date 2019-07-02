-- - create table

drop table emp_basic;
create or replace table emp_basic (
  first_name string ,
  last_name string ,
  email string ,
  streetaddress string ,
  city string ,
  start_date date
  );

create or replace file format my_csv_format
  type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true compression = gzip;

create or replace stage my_s3_stage url='s3://becloudready/data-analytics'
  credentials=(aws_key_id='<your key>' aws_secret_key='<your secred>')
  file_format = (type = csv field_optionally_enclosed_by='"');

copy into EMP_BASIC
  from s3://becloudready/data-analytics credentials=(aws_key_id='<your key>' aws_secret_key='<your secred>')
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees0[1-5].csv'
  on_error = 'skip_file';

  

copy into EMP_BASIC
  from @my_s3_stage
  file_format = (type = csv field_optionally_enclosed_by='"')
  pattern = '.*employees0[1-5].csv'
  on_error = 'skip_file';

create storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::001234567890:role/myrole'
  storage_allowed_locations = ('s3://mybucket1/mypath1/', 's3://mybucket2/mypath2/')
  storage_blocked_locations = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

