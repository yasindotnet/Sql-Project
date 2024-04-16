use DoctorDB
go
             ------------Insert---------------------
			 --------Insert compounder-----------

insert into compounder(compounder_id,compounder_name,compounder_phone_number,compounder_email)
 values 
        (1,'Hasan Sheikh',01571213706,'hasan89@gmail.com'),
        (2,'Pitu Biswas',01525659878,'ahmed98@gmail.com')
go
   select * from compounder

                      --------Insert doctor-----------
  insert into doctor(doctor_id,doctor_name)
 values  (1,'Lokman Hakim'),
         (2,'Hasibul Hasan Shanto'), 
		 (3,'Kamran Ahmed'),
         (4,'Sk Tuhin'), 
		 (5,'Bipul Hossen')
go
   select * from doctor

		             --------Insert dr_specialist-----------
 insert into Dr_specialist(doctor_id,specialist_name,fees)
 values  (1,'Medicine',1000),
         (2,'Gynocologist',800),
		 (3,'Opthalmologist',1000),
         (4,'Cardiologist',800),
		 (5,'Dentist',500)
go
   select * from Dr_specialist
		        --------Insert hospital-----------
 insert into hospital(hospital_id,hospital_name)
 values   (1,'BSMMU'),
          (2,'SSMC'),
	      (3,'DMC')
		          --------Insert Patient-----------
 insert into patient(patient_id,patient_name,Patient_address,patient_age,
 patient_phone_number,Patient_statues)

 values 
      (1,'Sharier Ahmed','Mirpur-1',27,01585784512,'Normal'),
      (2,'Sohag Hossen','Mirpur-10',35,01325689878,'Serious'),
      (3,'Kaniz Fatema','Shymoli',28,01478956859,'Normal'),
      (4,'Rakib khan','Farmagate',54,01731807660,'Normal'), 
      (5,'Shila akter','Mirpur-10',47,01726956999,'Normal'),
      (6,'Akram hossen','Shymoli',32,01782093877,'Serious'),
      (7,'Nazrul islam','Agargaon',60,01425876525,'Normal'), 
      (8,'Aysha khatun','Shahbaj',18,01717892042,'Normal'),
      (9,'Jiyadul islam','Shymoli',36,01518488348,'Serious'),
      (10,'Zakirul islam','Mirpur-10',34,01919800845,'Normal')
go
   select * from patient

	            --------------Insert Payment-----------
insert into Payment(payment_id,Total_payment,Advance_Payment,Advance_paymenrt_date)
 values
           (1,1000,800,'2023-08-20'),
           (2,800,650,'2023-08-20'),
           (3,500,500,'2023-08-23'),
           (4,1000,1000,'2023-08-02'),
           (5,800,800,'2023-08-11')
go
   select * from Payment

		      --------------Insert Transaction_1-----------
insert into transation_1(transation_id,compounder_id,doctor_id,Patient_id,hospital_id,payment_id)
values        
                (1,1,1,1,1,1),
                (2,1,3,2,2,2),
                (3,1,2,3,3,3),
                (4,1,4,4,1,4),
                (5,1,5,5,2,5),
                (6,2,1,6,3,1),
                (7,2,2,7,1,2),
                (8,2,3,8,3,4),
                (9,2,5,9,2,3),
                (10,2,4,10,1,4)
go
select * from transation_1
                   ----------view Tables---------
select * from compounder
select * from doctor
select * from Dr_specialist
select * from patient
select * from hospital
select * from Payment
select * from transation_1

go
          --------------delete-----------

           -----delete a single row--
delete from doctor where doctor_id=2;
         -----delete all records-
delete from doctor
 go
                 -------COUNT All Row------------
select count(*) as numberofpatient from patient;
            -------COUNT only one cloumn Row------------
select count(patient_id) as numberofpatient from patient
               ----------average------
select avg(advance_payment) as "averagepayment" from Payment
               ----------Maximum------
select Max(advance_payment) as "Maximumpayment" from Payment
                ----------Minimum------
select Min(advance_payment) as "Minimumpayment" from Payment
               ----------summetion------
select sum(advance_payment) as "sumofnpayment" from Payment
go
	       ----------case function---------
select Payment_id,sum(total_payment) as sumtotal,
  case 
     when sum(total_payment)<900
             then 'good'
    else 
	        'bad'
  end as paymentrange
from Payment
group by payment_id;
go
               ---------Coalesce function-------
select coalesce (null,null,'Medicine',null,'Gynocologist',null) as Experiences_sector
from Dr_specialist;
go
              -------like operator-----------
select patient_name,patient_address,patient_phone_number
from patient
where patient_name like'[aeiou]%'

select patient_name,patient_address,patient_phone_number,patient_address,patient_phone_number
from patient
where patient_name like 'a[a-z]'
go

                    ----------cube operator------
select patient_name,patient_address,count(*) as total
from patient
where patient_address in('Shymoli','Mirpur-10')
group by patient_name,patient_address with cube
order by patient_address desc;

		         ----------Rollup operator------		  
	select patient_name,patient_address,count(*) as total
from patient
where patient_address in('Shymoli','Mirpur-10')
group by patient_name,patient_address with rollup
order by patient_address desc;			

       
	        ----------grouping sets operator------
select patient_name,patient_address,count(*) as total
from patient
where patient_address in('Shymoli','Mirpur-10')
group by grouping sets(patient_name,patient_address)
order by patient_address desc,patient_name desc;	
              
			  ----------over clauses---------
select total_payment,advance_payment,Advance_paymenrt_date,sum(total_payment) 
over(order by advance_paymenrt_date) as sumtotal
from Payment
go
               ----------all keyword---------
select total_payment,advance_payment,Advance_paymenrt_date
from Payment join transation_1
on Payment.payment_id=transation_1.Patient_id
where Total_payment<all
(select Total_payment from Payment where payment_id=4)
go
               ----------any keyword---------
select total_payment,advance_payment,Advance_paymenrt_date
from Payment join transation_1
on Payment.payment_id=transation_1.Patient_id
where Total_payment<any
(select Total_payment from Payment where payment_id=2)
go
              ----------some keyword---------
select total_payment,advance_payment,Advance_paymenrt_date
from Payment join transation_1 
on Payment.payment_id=transation_1.Patient_id
where Total_payment<some
(select Total_payment from Payment where payment_id=5)
go
            ---------cast function--------
select total_payment,advance_paymenrt_date,
cast(advance_paymenrt_date as nvarchar) as nvarchardate,
cast(total_payment as int) as integertotal,
cast(total_payment as varchar) as varchartotal
from payment;
go

               ----Table joining-------
select patient.patient_name,Patient_address,patient_phone_number,compounder_name,doctor_name 
from patient join transation_1
on patient.patient_id=transation_1.Patient_id join doctor 
on doctor.doctor_id=transation_1.doctor_id join compounder
on transation_1.compounder_id=compounder.compounder_id
go

          ----------Table joining with where clause-------
select patient.patient_name,Patient_address,patient_phone_number,compounder_name,doctor_name 
from patient join transation_1
on patient.patient_id=transation_1.Patient_id join doctor 
on doctor.doctor_id=transation_1.doctor_id join compounder
on transation_1.compounder_id=compounder.compounder_id
where patient_age=60
go		
               --------join with group by and having------
select patient.patient_name,Patient_address,compounder_name,doctor_name,
count(patient.patient_age)
from patient join transation_1
on patient.patient_id=transation_1.Patient_id join doctor 
on doctor.doctor_id=transation_1.doctor_id join compounder
on transation_1.compounder_id=compounder.compounder_id
group by patient.patient_name,Patient_address
having patient_name='kaniz fatema'      
go
              ---------sub quary----------
select doctor.doctor_id,doctor_name,specialist_name,fees
from doctor join Dr_specialist on doctor.doctor_id=Dr_specialist.doctor_id
where fees>
(select avg(fees) from Dr_specialist)
order by doctor_id,fees
go

                     ----------Table value Function----------
create function fn_table()
returns table
return
(
select hospital_name from hospital
)
select * from dbo.fn_table();
go
                   --------------Scalar Value Function----------
create function fn_scalar()
   returns int
begin
  declare @c int;
  select @c = Count (*) from transation_1;
  return @c;
end
select dbo.fn_scalar();
go

                 ------------- Multistatement Function----------
create function fn_multi()
returns @outtable 
     table(payment_id int,Total_payment money,Advance_payment money, 
     Advance_paymenrt_date date,Advance_payment_ext money)
begin
   insert into @outtable(payment_id,Total_payment,Advance_payment,
   Advance_paymenrt_date,Advance_payment_ext)
   select payment_id,Total_payment,advance_payment,Advance_paymenrt_date,Advance_payment+100
   from Payment
  return;
end
select * from dbo.fn_multi();
go
              ------convert function-----
select total_payment,advance_paymenrt_date,
     convert(varchar,advance_paymenrt_date) as varchardate,
     convert(varchar,advance_paymenrt_date,1) as varchardate_1,
	 convert(varchar,advance_paymenrt_date,107) as varchardate_107,
	 convert(varchar,total_payment) as varchartotal,
	 convert(varchar,total_payment,1) as varchartotal_1
	 from Payment;
go

             -----------try_convert-----------
select total_payment,advance_paymenrt_date,
     try_convert(varchar,advance_paymenrt_date) as varchardate,
     try_convert(varchar,advance_paymenrt_date,1) as varchardate_1,
	 try_convert(varchar,advance_paymenrt_date,107) as varchardate_107,
	 try_convert(varchar,total_payment) as varchartotal,
	 try_convert(varchar,total_payment,1) as varchartotal_1,
	 try_convert(date,'aug 32,2023') as invaliddate
	 from Payment;
go
  ----------Ranking functions------
select 
      ROW_NUMBER() over(order by doctor_name) as rownumber,doctor_name from doctor;
select 
      Rank() over (order by total_payment) as rank,
      DENSE_RANK() over (order by total_payment) as denseranak,total_payment,advance_payment
	  from Payment;
select patient_name,
   ntile(2) over (order by patient_id) as  title2,
   ntile(3) over (order by patient_id) as  title3,
   ntile(4) over (order by patient_id) as  title4
from patient;
go
                -------analytic function-------
select payment_id,advance_paymenrt_date,total_payment,advance_payment,
PERCENT_RANK()  over (partition by advance_paymenrt_date order by total_payment) as pctrank,
CUME_DIST()     over (partition by advance_paymenrt_date order by total_payment) as cumdist,
PERCENTILE_CONT(.5) within group (order by total_payment) 
                over (partition by advance_paymenrt_date) as percentilecount,
PERCENTILE_DISC (.5) within group (order by total_payment) 
                 over (partition by advance_paymenrt_date) as percentiledisc
 from Payment;
 go


