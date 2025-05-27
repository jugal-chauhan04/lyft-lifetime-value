# lyft-lifetime-value  

### Driver Lifetime Value of Lyft Drivers  

**Task: Recommend a driver's liftetime value (i.e. the value of a driver to Lyft over the entire projected lifetime of the driver)**  

1. Recommend a Driver's Lifetime Value.
2. What are the main factors that affect a driver's lifetime value?
3. What is the average projected lifetime of a driver? That is, once a driver is onboarded, how long do they typically continue driving with Lyft?
4. Do all drivers act alike? Are there specific segments of drivers that generate more value for Lyft than the average driver?
5. What actionable recommendations are there for the business?

Prepare and submit a writeup of your findings for consumption by a cross-functional audience.  

### Data Description  

- driver_ids
    - driver_id: Unique identifier for a driver.
    - driver_onboard_date: Date on which driver was onboarded.  
   
- ride_ids
    - driver_id: Unique identifier for a driver
    - ride_id: Unique identifier for a ride that was completed by the driver
    - ride_distance: Ride distance in meters
    - ride_duration: Ride duration in seconds
    - ride_prime_time: Prime Time applied on the ride  
    
- ride_timestamps  
    - ride_id: Unique identifier for a ride
    - event: describes the type of event; this variable takes the following values:
        - requested_at - passenger requested a ride
        - accepted_at - driver accepted a passenger request
        - arrived_at - driver arrived at pickup point
        - picked_up_at - driver picked up the passenger
        - dropped_off_at - driver dropped off a passenger at destination
    - timestamp: Time of event  
    
Assumptions about the Lyft rate card:  

Base Fare $2.00  
Cost per Mile $1.15  
Cost per Minute $0.22  
Service Fee $1.75  
Minimum Fare $5.00  
Maximum Fare $400.00    

Assume that:

All rides in the data set occurred in San Francisco.
All timestamps in the data set are in UTC.  

### Driver Distribution  

<details>
    <summary> Click to view full sql query </summary>
<pre><code class="language-sql">
-- scripts/driver_distribution.sql
-- Determining the projected life distribution of lyft drivers.  

WITH driver_days AS
(
	SELECT
		d.driver_id,
		DATE_PART('day', MAX(t.timestamp) - MIN(d.driver_onboard_date)) AS diff
		-- Finding the duration a driver is associated with lyft
		-- We find the difference in days between drivers last ride and onboard date and call it diff
	FROM
		driver_ids d
	JOIN 
		ride_ids r
	ON 
		d.driver_id = r.driver_id
	JOIN
		ride_timestamps t
	ON 
		r.ride_id = t.ride_id
	WHERE
		t.event = 'dropped_off_at'  
		-- We select the last dropped off timestamp for calculation
	GROUP BY
		d.driver_id
	ORDER BY
		diff DESC
)
-- Here we will find number of drivers that last for particular days
SELECT
	diff AS n_days,
	COUNT(driver_id) AS n_drivers
FROM
	driver_days
GROUP BY
	diff
ORDER BY
	n_days ASC
</code>
</pre>

</details>


