DROP PROCEDURE getUserActivity;
DROP PROCEDURE getSeenMovies;
DROP PROCEDURE getDirectors;
DROP PROCEDURE getGenres;
DROP PROCEDURE getUserInfo;
DROP PROCEDURE getFollowerAmount;
DROP PROCEDURE isSeen;
DROP PROCEDURE getSeenFollowed;


DELIMITER //
CREATE PROCEDURE getUserActivity
(IN user CHAR(30))
BEGIN
  SELECT
    usr.username,
    ac.date, 
    fusr.username as friend_username,    
    acm.type,
    mov.title,
    mov.genre,
    mov.release_year,
    mov.director
  FROM
    Activity as ac    
    LEFT JOIN User as usr ON ac.user_id = usr.user_id
    LEFT JOIN Activity_friend as acf ON ac.activity_id = acf.activity_id
    LEFT JOIN User as fusr ON acf.friend_id = fusr.user_id      
    LEFT JOIN Activity_movie as acm ON ac.activity_id = acm.activity_id 
    LEFT JOIN Movie as mov ON acm.movie_id = mov.movie_id
  WHERE 
    ac.user_id != user     
  ORDER BY ac.date ASC; 
END //

CREATE PROCEDURE getSeenMovies
(IN id CHAR(30))
BEGIN
  SELECT
    m.movie_id,
    title,
    runtime,    
    release_year,    
    poster_path    
  FROM
    Movie as m
    JOIN Seen as s ON m.movie_id = s.movie_id
    JOIN User as u ON u.user_id = s.user_id    
  WHERE
    u.user_id = id;
END //

CREATE PROCEDURE getDirectors
(IN id CHAR(30))
BEGIN
  SELECT
  name
  FROM
    Director as d
    JOIN Movie_director as md ON d.director_id = md.director_id
    JOIN Movie as m ON m.movie_id = md.movie_id
  WHERE
    md.movie_id = id;
END //

CREATE PROCEDURE getGenres
(IN id CHAR(30))
BEGIN
  SELECT
  genre_type
  FROM
    Genre as g
    JOIN Movie_genre as mg ON g.genre_id = mg.genre_id
    JOIN Movie as m ON m.movie_id = mg.movie_id
  WHERE
    mg.movie_id = id;
END //

CREATE PROCEDURE getUserInfo
(IN id CHAR(30))
BEGIN
  SELECT
    usr.username,
    uinf.name,
    uinf.created as join_date
  FROM
    User as usr   
    Join User_info as uinf on usr.user_id = uinf.user_id  
  WHERE
    usr.user_id = id;  
END //

CREATE PROCEDURE getFollowerAmount
(IN id CHAR(30))
BEGIN
  SELECT  
    COUNT(ufri.friend_id) as follower_amount
  FROM    
    User_friend as ufri
  WHERE
    ufri.user_id = id;  
END //

CREATE PROCEDURE isSeen
(IN u_id CHAR(30), IN m_id CHAR(30))
BEGIN
  SELECT  
    COUNT(*) as is_seen
  FROM    
    Seen as s
  WHERE
    s.user_id = u_id
    AND s.movie_id = m_id;  
END //

CREATE PROCEDURE getSeenFollowed
(IN u_id CHAR(30), IN m_id CHAR(30))
BEGIN
  SELECT  
    u2.username,
    s.date
  FROM    
    User as u
    JOIN User_friend as uf ON u.user_id = uf.user_id
    JOIN User as u2 ON uf.friend_id = u2.user_id
    JOIN Seen as s ON uf.friend_id = s.user_id
  WHERE
    u.user_id = u_id
    AND s.movie_id = m_id;  
END //

DELIMITER ;