use hospital

--[Hospital Database]

--Q01
begin transaction 
update Patients 
set WardId=2
where id=1
commit transaction;
--Q02
begin transaction
update Consultants
set Salary = Salary + 5000
where Id=1
rollback transaction
--Q03
begin transaction
update Patients
set WardId=3
where Id=1

update Nurses
set ServesInWardId=3
where Number=1
commit transaction
--Q04
begin transaction
update Patients
set WardId=2
where Id =1
save transaction PatientUpdate
update Patients
set Name = 'Test'
WHERE Id = 1;
ROLLBACK TRANSACTION PatientUpdate
commit transaction
--Q05
begin try
begin transaction
update Consultants
set Salary+=3000
where Id=1
COMMIT  transaction;
end try
begin catch
if @@TRANCOUNT>0
rollback transaction
select ERROR_NUMBER() as ERRORNUMBER,ERROR_MESSAGE() as ERROENAME
end catch
--Q06 
go
create view vw_ConsultantPatientStatistics
as 
select c.Id AS ConsultantId ,c.Name AS ConsultantName,c.Salary AS ConsultantSalary,count(PCA.PatientId) AS AssignedPatientCount
from Consultants c 
join PatientConsultantAssignments PCA on c.Id=PCA.ConsultantId
group by c.Id,c.Name,c.Salary
--Q07
select *
from vw_ConsultantPatientStatistics
where AssignedPatientCount>5;
--Q08
go 
create view vw_IndexedConsultantPatientCount
with schemabinding
as 
select ConsultantId as CID ,Count_Big(*)  AS AssignedPatientCount
from dbo.PatientConsultantAssignments
group by ConsultantId
create unique clustered index IX_vw_IndexedConsultantPatientCount
on dbo.vw_IndexedConsultantPatientCount (CID);
--Q09
select *
FROM dbo.vw_IndexedConsultantPatientCount
WHERE AssignedPatientCount > 5;
--Q10
select 
    name AS ViewName,
    create_date AS CreationDate,
    modify_date AS ModificationDate
from sys.views;
--Q11
SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('vw_PatientInformation');
--Q12
ALTER VIEW vw_PatientInformation AS --Almfrood Enha Mogoda ya3ni
SELECT 
    Id AS PatientId,
    Name AS PatientName,
    DOB AS DateOfBirth
FROM Patients;
--Q13
DROP VIEW vw_ConsultantSalary;
--Q14
go
create view vw_PatientHospitalReport
as 
select p.Id as PatientId,p.Name as PatientName,p.DOB as DOB,w.Name as WardName , c.Name as ConsultantName
from Patients p left join Wards w
on p.WardId= w.Id
left join PatientConsultantAssignments pca 
on p.Id=pca.PatientId
left join Consultants c on c.Id=pca.ConsultantId
go
--Q15
select *
from vw_PatientHospitalReport
where ConsultantName IS NOT NULL;
--Q16
select 
    PatientName,
    WardName,
    ConsultantName
From vw_PatientHospitalReport
Where WardName = 'cardiology';
--Q17
select TOP 1* 
from vw_ConsultantPatientStatistics
order BY AssignedPatientCount DESC

--Q18
select *
from vw_PatientAgeInformation --Almfrood Enha Mogoda ya3ni
where Age > 60;
--Q19
select *
from vw_ConsultantPatientStatistics
order by AssignedPatientCount Desc
--Q20
select 
    WardName,
    COUNT(*) AS NumberOfPatients
from vw_PatientWardInformation --Almfrood Enha Mogoda ya3ni
GROUP BY WardName;
--Q21
SELECT 
    s.name AS SchemaName,
    v.name AS ViewName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
JOIN sys.indexes i ON v.object_id = i.object_id
WHERE i.index_id > 0;
--=====