create database pratice_schema;
use pratice_schema;

-- 1.  Import the csv file to a table in the database.
       select * from `icc test batting figures`;
       alter table `icc test batting figures` rename `batting`;
   
   
   
-- 2. Remove the column 'Player Profile' from the table.
	  alter table batting drop `player profile`;
   
-- 3. Extract the country name and player names from the given data and store it in 
--    seperate columns for further usage.
      select * from batting;
      alter table batting add player_name varchar(50);
      alter table batting add country_name varchar(50);
      update batting set player_name =substring_index(Player,'(',1);
      update batting set country_name =substring_index((replace(substring_index(player,
      '(',-1),')','')),'/',-1);

    
    
    
    
-- 4. From the column 'Span' extract the start_year and end_year and store them in 
--    seperate columns for further usage.
      alter table batting add start_year int;
      update batting set start_year=substring_index(span,'-',1);
      alter table batting add end_year int;
      update batting set end_year= substring_index(span,'-',-1);
	  select * from batting;
   
-- 5. The column 'HS' has the highest score scored by the player so far in any given
--    match. The column also has details if the player had completed the match in a
--    NOT OUT status. Extract the data and store the highest runs and the NOT OUT status 
--    in different columns.
      alter table batting add highest_runs int;
      update batting set highest_runs=substring_index(HS,'*',1);
	  alter table batting add status varchar(10);
	  update batting set status=if(HS like '%*','Not_Out','OUT');
      select * from batting;


-- 6. Using the data given, considering the players who were active in 
--    the year of 2019, create a set of batting order of best 6 players using the 
--    selection criteria of those who have a good average score across all matches for India.
	   select player_name from batting 
       where end_year=2019 and country_name='India' order by Avg desc limit 6;
       select * from
       (select player_name ,rank()over(order by avg desc)rnk,avg from batting
        where end_year=2019 and country_name='India')t where rnk<=6;

         select * from batting;
-- 7. Using the data given, considering the players who were active in the year of 2019,
--    create a set of batting order of best 6 players using the selection criteria of those 
--    who have highest number of 100s across all matches for India.
       select * from
      (select player_name ,rank()over(order by `100` desc) rnk_100,`100` from batting
       where end_year=2019 and country_name='India')t where rnk_100<7;

-- 8. Using the data given, considering the players who were active in the year of 2019, 
--    create a set of batting order of best 6 players using 2 selection criterias of your 
--    own for India.
       select * from
      (select player_name ,rank()over(order by avg desc, `100` desc) rnk_crit,`100`,avg from batting
       where end_year=2019 and country_name='India')t where rnk_crit<=6;

-- 9. Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
--    considering the players who were active in the year of 2019, create a set of batting 
--    order of best 6 players using the selection criteria of those who have 
--    a good average score across all matches for South Africa.
    create view Batting_Order_GoodAvScorers_SA as
	select * from
	(select player_name ,rank()over(order by avg desc) rnk_crit,avg from batting
    where end_year=2019 and country_name='SA')t where rnk_crit<=6;
    select * from Batting_Order_GoodAvScorers_SA;
    
-- 10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, 
--    considering the players who were active in the year of 2019, create a set of batting 
--    order of best 6 players using the selection criteria of those who have highest number 
--    of 100s across all matches for South Africa.
	  create view Batting_Order_HighestCenturyScorers_SA as
      select * from
      (select player_name ,rank()over(order by `100` desc) rnk_crit,`100` from batting
      where end_year=2019 and country_name='SA')t where rnk_crit<=6;
      select * from Batting_Order_HighestCenturyScorers_SA;
      select * from
      (select country_name,max(rn)over(order by country_name)
	  max_number_of_players_from_each_country from
	  (select country_name,row_number()over(partition by country_name) as rn
      from batting)t)t1
      group by country_name;