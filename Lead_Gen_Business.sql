# 1. What query would you run to get the total revenue for March of 2012?
select monthname(charged_datetime) as month, sum(amount) as revenue from billing
where MONTH(charged_datetime) = 3 and YEAR(charged_datetime) = 2012;

# 2. What query would you run to get total revenue collected from the client with an id of 2?
select clients.client_id, sum(billing.amount) as revenue from clients
left join billing on clients.client_id = billing.client_id
where clients.client_id = 2;

# 3. What query would you run to get all the sites that client=10 owns?
select sites.domain_name, clients.client_id from clients
left join sites on clients.client_id = sites.client_id
where clients.client_id = 10;

# 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
-- Client id = 1
select clients.client_id, count(domain_name) as number_of_websites, monthname(sites.created_datetime) as month_created, year(sites.created_datetime) as year_created from clients
left join sites on clients.client_id = sites.client_id
where clients.client_id = 1
group by domain_name;
-- Client id = 20
select clients.client_id, count(domain_name) as number_of_websites, monthname(sites.created_datetime) as month_created, year(sites.created_datetime) as year_created from clients
left join sites on clients.client_id = sites.client_id
where clients.client_id = 20
group by domain_name;

# 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
select sites.domain_name as website, count(sites.domain_name) as number_of_leads, DATE_FORMAT(leads.registered_datetime,'%M %d, %Y') as date_generated from sites
left join leads on sites.site_id = leads.site_id
where leads.registered_datetime between '2011/01/01' and '2011/02/15'
group by sites.domain_name;

# 6. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients between January 1, 2011 to December 31, 2011?
select concat(clients.first_name, ' ', clients.last_name) as client_name, count(sites.domain_name) as number_of_leads from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id
where leads.registered_datetime between '2011/01/01' and '2011/12/31'
group by clients.client_id;

# 7. What query would you run to get a list of client names and the total # of leads we've generated for each client each month between months 1 - 6 of Year 2011?
select concat(clients.first_name, ' ', clients.last_name) as client_name, count(sites.domain_name) as number_of_leads, monthname(leads.registered_datetime) as month_generated from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id
where MONTH(leads.registered_datetime) between 1 and 6 and YEAR(leads.registered_datetime) = 2011
group by leads.registered_datetime;

# 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites between January 1, 2011 to December 31, 2011? 
#	 Order this query by client id.  Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
-- First Query
select concat(clients.first_name, ' ', clients.last_name) as client_name, sites.domain_name as website, count(leads.leads_id) as number_of_leads, DATE_FORMAT(leads.registered_datetime,'%M %d, %Y') as date_generated from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id
where leads.registered_datetime between '2011/01/01' and '2011/12/31'
group by sites.domain_name
order by clients.client_id, MONTH(leads.registered_datetime);
-- Second Query
select concat(clients.first_name, ' ', clients.last_name) as client_name, sites.domain_name as website, count(leads.leads_id) as number_of_leads from clients
left join sites on clients.client_id = sites.client_id
left join leads on sites.site_id = leads.site_id
group by sites.domain_name
order by clients.client_id, number_of_leads desc;

# 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
select concat(clients.first_name, ' ', clients.last_name) as client_name, sum(billing.amount) as total_revenue, monthname(billing.charged_datetime) as month_charge, year(billing.charged_datetime) as year_charge from clients
left join billing on clients.client_id = billing.client_id
group by clients.client_id, billing.charged_datetime
order by clients.client_id, billing.charged_datetime;

# 10. Write a single query that retrieves all the sites that each client owns. Group the results so that each row shows a new client. 
#	  It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
select concat(clients.first_name, ' ', clients.last_name) as client_name, group_concat(sites.domain_name ORDER BY sites.domain_name ASC SEPARATOR ' / ') as sites from clients
left join sites on clients.client_id = sites.client_id
group by clients.client_id;
