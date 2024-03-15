create database imdb;
use imdb;
show databases;


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

## role_mapping table
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM role_mapping;

## movie table
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM movie;

## genre
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM genre;

## ratings
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM ratings;

## director_mappping
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM director_mapping;

## names
SELECT count(*) AS TOTAL_NO_OF_ROWS
FROM names;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(CASE WHEN id is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(id) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN title is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(title) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN year is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(year) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN date_published is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(date_published) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN duration is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(duration) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN country is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(country) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN worlwide_gross_income is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(worlwide_gross_income) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN languages is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(languages) AS Number_Of_Non_NullValues
FROM movie;

SELECT SUM(CASE WHEN production_company is null THEN 1 ELSE 0 END) 
AS No_of_null_values,
COUNT(production_company) AS Number_Of_Non_NullValues
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */


SELECT Year,count(year) AS number_of_movies
FROM movie
group by year;

SELECT MONTH(date_published) AS month_num,count(year) AS number_of_movies
FROM movie
group by month_num
order by month_num;

-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT country,count(year) AS number_of_movies
FROM movie
WHERE (country = 'USA' OR country = 'India') AND (year = 2019);

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT DISTINCT genre,count(year) AS number_of_movies
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id
group by genre
order by number_of_movies DESC limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(movie_id)
FROM 
(SELECT movie_id, COUNT(genre) AS Total_count
FROM genre
group by (movie_id)
HAVING Total_count=1
order by (movie_id)) AS no_of_movies;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,round(avg(duration)) as avg_duration
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id
group by genre
order by avg_duration DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/

SELECT *
FROM
(SELECT genre,COUNT(movie_id) AS movies_produced,
rank() over(order by COUNT(movie_id)DESC) as genre_rank
FROM genre
group by genre) AS movie_rank
where genre = 'thriller';

SELECT genre,COUNT(movie_id) as m
FROM genre
group by genre
order by m DESC limit 3;

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_rating, 
MAX(avg_rating) AS max_rating, 
MIN(total_votes) AS min_total_votes,
MAX(total_votes) AS max_total_votes, 
MIN(median_rating) AS min_median_rating, 
MAX(median_rating) AS max_median_rating
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT title,avg_rating,
DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings as r
INNER JOIN movie as m
ON m.id = r.movie_id
GROUP BY avg_rating limit 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count ;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,COUNT(movie_id) AS movie_count,
RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE (avg_rating>8) AND (production_company IS NOT NULL)
GROUP BY production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,COUNT(g.movie_id) AS movie_count
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id 
INNER JOIN ratings as r
ON r.movie_id = m.id  
WHERE (total_votes >1000) AND (date_published BETWEEN '2017/03/01' AND '2017/03/31') AND COUNTRY = 'USA'
GROUP  BY genre
ORDER  BY movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,avg_rating,genre
FROM movie as m
INNER JOIN genre as g
ON g.movie_id = m.id 
INNER JOIN ratings as r
ON r.movie_id = m.id 
WHERE (title LIKE 'The%') AND (avg_rating>8)
GROUP BY title
ORDER BY avg_rating DESC;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT median_rating, COUNT(movie_id) AS count_of_movies
FROM movie as m
INNER JOIN ratings as r
ON r.movie_id = m.id 
WHERE date_published BETWEEN '2018/01/01' AND '2019/01/01' AND median_rating=8;

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country,sum(total_votes) as total_votes
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE country = 'Germany' OR country = 'Italy'
GROUP BY country
ORDER BY total_votes DESC;

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT SUM(CASE WHEN name is null THEN 1 ELSE 0 END) 
AS name_nulls
FROM names;

SELECT SUM(CASE WHEN height is null THEN 1 ELSE 0 END) 
AS height_nulls
FROM names;

SELECT SUM(CASE WHEN date_of_birth is null THEN 1 ELSE 0 END) 
AS date_of_birth_nulls
FROM names;

SELECT SUM(CASE WHEN known_for_movies is null THEN 1 ELSE 0 END) 
AS known_for_movies_nulls
FROM names;

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.NAME AS director_name , Count(d.movie_id) AS movie_count
FROM director_mapping  AS d
INNER JOIN genre g
ON g.movie_id = d.movie_id
INNER JOIN names AS n
ON n.id = d.name_id
INNER JOIN 
( SELECT     genre, Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
FROM movie AS m
INNER JOIN genre AS g
ON g.movie_id = m.id
INNER JOIN ratings AS r
ON r.movie_id = m.id
WHERE r.avg_rating > 8
GROUP BY g.genre limit 3 ) genres
ON g.genre = genres.genre
INNER JOIN ratings as r
ON r.movie_id = d.movie_id
WHERE      r.avg_rating > 8.0
GROUP BY   n.name
ORDER BY   movie_count DESC limit 3 ;

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select distinct name as actor_name, count(r.movie_id) as movie_count
from ratings as r
inner join role_mapping as rm
	on rm.movie_id = r.movie_id
inner join names as n
	on rm.name_id = n.id
where median_rating >= 8 and category = 'actor'
group by name
order by movie_count desc
limit 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select m.production_company as production_company, sum(r.total_votes) as vote_count, dense_rank() over( order by sum(r.total_votes) desc) as prod_comp_rank 
from movie m
inner join ratings r
on m.id = r.movie_id
group by production_company;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actor_name, r.total_votes as total_votes, count(m.id) as movie_count,
	   sum(r.avg_rating*r.total_votes)/sum(r.total_votes) as actor_avg_rating,
	   rank() over(order by r.avg_rating desc) as actor_rank
from movie m 
inner join ratings r 
	on m.id = r.movie_id 
inner join role_mapping rm 
	on m.id=rm.movie_id 
inner join names n 
	on rm.name_id=n.id
where category='actor' and country= 'india'
group by n.name
having count(m.id)>=5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select n.name as actor_name, r.total_votes as total_votes, count(m.id) as movie_count,
	   (sum(r.avg_rating*r.total_votes)/sum(r.total_votes)) as actress_avg_rating,
	   rank() over(order by r.avg_rating desc) as actress_rank
from movie m 
inner join ratings r 
	on m.id = r.movie_id 
inner join role_mapping rm 
	on m.id=rm.movie_id 
inner join names n 
	on rm.name_id=n.id
where category='actress' and country='india'and languages = 'hindi'
group by n.name
having count(m.id)>=3
limit 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select m.title, case when r.avg_rating > 8 then 'Superhit movies'
				     when r.avg_rating between 7 and 8 then 'Hit movies'
                     when r.avg_rating between 5 and 7 then 'One-time-watch movies'
				     when r.avg_rating < 5 then 'Flop movies'
		        end as avg_rating_category
from movie m
inner join genre g
	on m.id = g.movie_id
inner join ratings as r
	on m.id=r.movie_id
where g.genre='thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       avg(duration) AS avg_duration,
       sum(avg(duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       avg(avg(duration)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre;

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT *, Rank() over(ORDER BY movie_count DESC) AS prod_comp_rank
FROM   
(SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                INNER JOIN ratings AS r
                ON r.movie_id = m.id
         
         WHERE  median_rating >= 8 AND production_company IS NOT NULL AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC) production_company_movie_count
LIMIT 2; 

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT   *, Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM 
(
    SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id) AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           
           FROM movie AS m
           
           INNER JOIN ratings AS r
           ON m.id=r.movie_id
           
           INNER JOIN role_mapping AS r_m
           ON m.id = r_m.movie_id
           
           INNER JOIN names AS n
           ON r_m.name_id = n.id
           
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           
           WHERE category = "ACTRESS" AND avg_rating>8.0 AND genre = "Drama"
           GROUP BY NAME ) actress
LIMIT 3;















