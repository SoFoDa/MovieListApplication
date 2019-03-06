DROP PROCEDURE getUserActivity;
DROP PROCEDURE getSeenMovies;


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
    title,
    runtime,
    genre,
    release_year,
    director,
    poster_path
  FROM
    Movie as m
    INNER JOIN Seen as s ON m.movie_id = s.movie_id
    INNER JOIN User as u ON u.user_id = s.user_id
  WHERE
    u.user_id = id;
END //

DELIMITER ;