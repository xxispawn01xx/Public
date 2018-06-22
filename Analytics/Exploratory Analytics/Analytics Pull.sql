/*Q1
For request times between 12/1/2013 10:00:00 PST & 12/8/2013 17:00:00 PST, how
many completed trips (Hint: look at the trips.status column) were requested on iphones
in City #5? on android phones?

*/

select Count(id) as CompletedTrips
from trips 
where status='completed' and (request_device='iphone' OR request_device='android')
and city_id=5
and request_at >= '2013-12-01 10:00:00' 
	   AND request_at <= '2013-12-08 17:00:00'


/*Q2
In City #8, how many unique, currently unbanned clients requested a trip in October
2013 that was eventually completed? 
*/
select count(distinct client_id) as TotalClients
from 
trips t
inner join Users U on t.client_id=u.UserID and u.role='client' and u.banned=0
where city_id=8
and year(request_at)=2013 and month(request_at)=10
and status='completed' 

/*Q2- Part B
Of these, how many trips did each client take?
*/
select distinct u.UserID as ClientID, U.firstname, U.lastname, Count(t.id) as TotalTrips
from 
trips t
inner join Users U on t.client_id=u.UserID and u.role='client' and u.banned=0
where city_id=8
and year(request_at)=2013 and month(request_at)=10
and status='completed' 
group by u.UserID , U.firstname, U.lastname
