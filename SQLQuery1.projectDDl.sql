go
drop database DoctorDB
create database DoctorDB
on primary
(
name='DoctorDB_data_1',
Filename='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DoctorDB_data_1.mdf',
    Size=25mb,
	Maxsize=100mb,
	FileGrowth=5%
	)
 log on
  (
name='DoctorDB_Log_1',
Filename='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\DoctorDB_Log_1.ldf',
    Size=25mb,
	Maxsize=100mb,
	FileGrowth=5%
	)
go
create table compounder(
 compounder_id int primary key,
 compounder_name varchar(50),
 compounder_phone_number int,
 compounder_email varchar(50)
 );
 go
 create table doctor(
 doctor_id int primary key,
 doctor_name varchar(50)
 );
go
 create table Dr_specialist(
 doctor_id int references doctor(doctor_id),
 specialist_name varchar(50),
 fees money
 );

go

 create table patient(
 patient_id int primary key,
 patient_name varchar(50),
 Patient_address varchar(50),
 patient_age int,
 patient_phone_number int,
 Patient_statues varchar(50)
 );
 go

 create table hospital(
 hospital_id int primary key,
 hospital_name varchar(50)
 );
go

 create table Payment(
 payment_id int primary key,
 Total_payment money,
 Advance_Payment money,
 Advance_paymenrt_date date,
 );
 go

 create table transation_1(
transation_id int primary key,
compounder_id int references compounder(compounder_id),
doctor_id int references doctor(doctor_id),
Patient_id int references patient(patient_id),
hospital_id int references hospital(hospital_id),
payment_id int references payment(payment_id)
);
go                                         
                  --------store procedure select-insert-update-delete--------
use DoctorDB
select * from doctor
go
create procedure sp_select_insert_update_delete
(
  @doctor_id int,
  @doctor_name varchar(50),
  @statementtype nvarchar(40)=''
)
as
    IF @statementtype='select'
begin
    select * from doctor
end
    IF @statementtype='insert'
begin
       insert into doctor(doctor_id,doctor_name)
       values(@doctor_id,@doctor_name)
end
      IF @statementtype='update'
begin
     update doctor
     set doctor_id=@doctor_id
     where doctor_name=@doctor_name
end
     IF @statementtype='delete'
begin
     delete doctor
     where doctor_id=@doctor_id
end
go
           -------Execute in store procedure----
exec sp_select_insert_update_delete 6,'yasin ali','insert'
exec sp_select_insert_update_delete 6,'Nifaz mollah','update'
exec sp_select_insert_update_delete 6,'Nifaz mollah','delete'

go             

             ---------store procedure input parameter----
select * into doctorcopy from doctor

go
create procedure sp_input
@doctor_id int,
@doctor_name varchar(50)
as
insert into doctorcopy values(@doctor_id,@doctor_name)
go
                -------Execute in store procedure input----
      exec sp_input 6,'Mehidi hasan'	
	  
	          ---------store procedure output parameter----
go
create procedure sp_output
@doctor_id int output
as
select count(*) from doctorcopy

              ---------store procedure return parameter----
go
create procedure sp_return
(@doctor_id int)
as
select doctor_id,doctor_name from doctorcopy
where doctor_id=@doctor_id
go
declare @Return_value int
exec @Return_value=sp_return
@doctor_id=2
select 'Return_value'=@Return_value
go
              -----------instead of trigger-----
use DoctorDB
select * into hospitalcopy from hospital
insert into hospitalcopy  
values(4,'BIRDEM')
go
drop table if exists hospitallog
create table hospitallog(
logid int identity (1,1) not null,
hospital_id int null,
actionlog varchar(50) null
);
go
create trigger tr_insteadof
   on hospitalcopy
   instead of delete
   as
begin
       declare @hospital_id int
       select @hospital_id=deleted.hospital_id
       from deleted
 if @hospital_id=2
    begin
       raiserror ('id 2 cannot be delete',16,1)
           rollback
       insert into hospitallog
       values(@hospital_id,'record cannot be delete')
     end
 else
    begin
       delete from hospitalcopy
       where hospital_id=@hospital_id
       insert into hospitallog
       values(@hospital_id,'instead of delete')
    end
end
go
                 ------execute of instead of delete-------
delete hospitalcopy
where hospital_id=2

select * from hospitallog
select * from hospitalcopy

                  -------create view----------
create view vi_doc
as
select * from doctor

select * from vi_doc
go
                   ----------view encryption------
create view vi_ency
with encryption
as
select * from doctor

select * from vi_ency
go
                  ---------view scheamabinding-------
create view vi_sch
with schemabinding
as
select compounder_name,compounder_email from dbo.compounder

select * from dbo.vi_sch
go
                  ----------index---------
create index ix_compounder
on compounder(compounder_name);

create nonclustered index ix_doctor
on doctor(doctor_name);
go

                  ------merge table-----
drop table if exists Payment_merge
create table Payment_merge(
 payment_id int primary key,
 Total_payment money,
 Advance_Payment money,
 Advance_paymenrt_date date,
 );
select * from Payment_merge
go







             