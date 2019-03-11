USE mydb;
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table User; 
TRUNCATE table User_friend; 
TRUNCATE table User_info; 
TRUNCATE table Movie;
TRUNCATE table Seen;
TRUNCATE table Activity;
TRUNCATE table Activity_friend;
TRUNCATE table Activity_movie;

TRUNCATE table Movie_genre;
TRUNCATE table Movie_director;
TRUNCATE table Genre;
TRUNCATE table Director;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO User (username, password) VALUES ('johankjip', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (1, 'Johan', NOW());
INSERT INTO User (username, password) VALUES ('sofoda', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (2, 'David', NOW());
INSERT INTO User (username, password) VALUES ('vrooomstah', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (3, 'Erik', NOW());
INSERT INTO User (username, password) VALUES ('elonmusk', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (4, 'Elon Musk', NOW());

INSERT INTO User_friend (user_id, friend_id) VALUES (1, 2);
INSERT INTO User_friend (user_id, friend_id) VALUES (2, 1);
INSERT INTO User_friend (user_id, friend_id) VALUES (2, 3);

INSERT INTO Director (name) VALUES ('George Lucas');
INSERT INTO Director (name) VALUES ('Denis Villeneuve');
INSERT INTO Genre (genre_type) VALUES ('Action');
INSERT INTO Genre (genre_type) VALUES ('Adventure');
INSERT INTO Genre (genre_type) VALUES ('Fantasy');
INSERT INTO Genre (genre_type) VALUES ('Sci-Fi');
INSERT INTO Genre (genre_type) VALUES ('Drama');
INSERT INTO Genre (genre_type) VALUES ('Mystery');
INSERT INTO Genre (genre_type) VALUES ('Thriller');

INSERT INTO Movie (title, runtime, release_year, poster_path) VALUES ('Star Wars: Episode IV - A New Hope', 121, 1977, 'star-wars:-episode-iv---a-new-hope1977.jpg');
INSERT INTO Movie (title, runtime, release_year, poster_path) VALUES ('Blade Runner 2049', 164, 2017, 'blade-runner-2049.jpg');

INSERT INTO Movie_genre (movie_id, genre_id) VALUES (1, 1);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (1, 2);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (1, 3);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (1, 4);

INSERT INTO Movie_genre (movie_id, genre_id) VALUES (2, 5);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (2, 6);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (2, 4);
INSERT INTO Movie_genre (movie_id, genre_id) VALUES (2, 7);

INSERT INTO Movie_director (movie_id, director_id) VALUES (1, 1);
INSERT INTO Movie_director (movie_id, director_id) VALUES (2, 2);

INSERT INTO Seen (user_id, movie_id, date) VALUES (1, 1, NOW());
INSERT INTO Seen (user_id, movie_id, date) VALUES (1, 2, NOW());
INSERT INTO Seen (user_id, movie_id, date) VALUES (2, 1, NOW());
INSERT INTO Seen (user_id, movie_id, date) VALUES (2, 2, NOW());
INSERT INTO Seen (user_id, movie_id, date) VALUES (3, 2, NOW());
INSERT INTO Seen (user_id, movie_id, date) VALUES (4, 1, NOW());

INSERT INTO Activity (user_id, date) VALUES (1, NOW());
INSERT INTO Activity_friend (activity_id, friend_id) VALUES (1, 2);
INSERT INTO Activity (user_id, date) VALUES (1, NOW());
INSERT INTO Activity_friend (activity_id, friend_id) VALUES (2, 3);
INSERT INTO Activity (user_id, date) VALUES (2, NOW());
INSERT INTO Activity_friend (activity_id, friend_id) VALUES (3, 1);
INSERT INTO Activity (user_id, date) VALUES (1, NOW());
INSERT INTO Activity_movie (activity_id, movie_id, type) VALUES (4, 1, 'rate');
INSERT INTO Activity (user_id, date) VALUES (2, NOW());
INSERT INTO Activity_movie (activity_id, movie_id, type) VALUES (5, 2, 'seen');
INSERT INTO Activity (user_id, date) VALUES (3, NOW());
INSERT INTO Activity_movie (activity_id, movie_id, type) VALUES (6, 1, 'favourite');
INSERT INTO Activity (user_id, date) VALUES (4, NOW());
INSERT INTO Activity_movie (activity_id, movie_id, type) VALUES (7, 2, 'seen');





