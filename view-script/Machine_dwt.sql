set search_path to industrial_machine;
select * from machine_downtime;


---Changing the data type for Date column
alter table machine_downtime
alter column "Date" type date
using to_date("Date",'DD-MM-YYYY');

---Checking column data types
select * from information_schema.columns
where table_schema= 'industrial_machine'
and table_name='machine_downtime'

---Renaming Date column (keywords used as column names cause confusion)
alter table machine_downtime rename "Date" to "recorded_date"


---Renaming other columns for ease during querrying
alter table machine_downtime rename "Machine_ID" to "machine_id";
alter table machine_downtime rename "Assembly_Line_No" to "assembly_line_no";
alter table machine_downtime rename "Hydraulic_Pressure(bar)" to "hydraulic_pressure_bar";
alter table machine_downtime rename "Coolant_Pressure(bar)" to "coolant_pressure_bar";
alter table machine_downtime rename "Air_System_Pressure(bar)" to "airsystem_pressure_bar";
alter table machine_downtime rename "Coolant_Temperature" to "coolant_temp";
alter table machine_downtime rename "Hydraulic_Oil_Temperature" to "hydraulic_oil_temp";
alter table machine_downtime rename "Spindle_Bearing_Temperature" to "spindle_bearing_temp";
alter table machine_downtime rename "Spindle_Vibration" to "spindle_vibration";
alter table machine_downtime rename "Tool_Vibration" to "tool_vibration";
alter table machine_downtime rename "Spindle_Speed(RPM)" to "spindle_speed_rpm";
alter table machine_downtime rename "Voltage(volts)" to "volts";
alter table machine_downtime rename "Torque(Nm)" to "torque_nm";
alter table machine_downtime rename "Cutting(kN)" to "cutting_kn";
alter table machine_downtime rename "Downtime" to "downtime";

---Checking for nulls
select count(*) from machine_downtime
where recorded_date is null 
or machine_id  is null
or airsystem_pressure_bar is null
or assembly_line_no is null
or coolant_pressure_bar is null
or coolant_temp is null 
or cutting_kn is null
or downtime is null
or hydraulic_oil_temp is null
or hydraulic_pressure_bar is null
or spindle_bearing_temp is null
or spindle_vibration is null
or spindle_speed_rpm is null
or tool_vibration is null
or torque_nm is null
or volts is null;

---Replacing Nulls with 0
update machine_downtime
set hydraulic_pressure_bar=0
where hydraulic_pressure_bar is null;

update machine_downtime
set coolant_pressure_bar =0
where coolant_pressure_bar  is null;

update machine_downtime
set airsystem_pressure_bar=0
where airsystem_pressure_bar  is null;

update machine_downtime
set coolant_temp=0
where coolant_temp  is null;

update machine_downtime
set hydraulic_oil_temp=0
where hydraulic_oil_temp is null;

update machine_downtime
set spindle_bearing_temp=0
where spindle_bearing_temp is null;

update machine_downtime
set spindle_vibration=0
where spindle_vibration  is null;

update machine_downtime
set tool_vibration=0
where tool_vibration  is null;

update machine_downtime
set spindle_speed_rpm=0
where spindle_speed_rpm  is null;

update machine_downtime
set volts=0
where volts is null;

update machine_downtime
set torque_nm= coalesce(torque_nm,0);

update machine_downtime
set cutting_kn= coalesce(cutting_kn,0);


---total machines in the industry
select count(distinct machine_id) from machine_downtime;

--What is the first and last date readings were taken on?
select min(recorded_date) as first_date, max(recorded_date) as last_date
from machine_downtime;

--What is the average Torque?
select (avg(torque_nm))::numeric(10,2) as average_torque
from machine_downtime;

--Which assembly line has the highest readings of machine downtime?
select assembly_line_no,count(downtime) as total_downtime 
from machine_downtime
where downtime= 'Machine_Failure'
group by assembly_line_no
order by total_downtime desc;

select assembly_line_no,machine_id,count(downtime) as total_downtime 
from machine_downtime
where downtime= 'Machine_Failure'
group by assembly_line_no, machine_id 
order by total_downtime desc;

select machine_id, sum(volts) as total_voltage
from machine_downtime
group by machine_id 
order by total_voltage desc;
