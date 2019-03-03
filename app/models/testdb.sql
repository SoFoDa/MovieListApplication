USE mydb;
SET FOREIGN_KEY_CHECKS = 0; 
TRUNCATE table User; 
TRUNCATE table User_friend; 
TRUNCATE table User_info; 
TRUNCATE table Movie;
TRUNCATE table Seen;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO User (username, password) VALUES ('JohanKJIP', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (1, 'Johan', NOW());
INSERT INTO User (username, password) VALUES ('Sofoda', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (2, 'David', NOW());
INSERT INTO User (username, password) VALUES ('Vrooomstah', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (3, 'Erik', NOW());
INSERT INTO User (username, password) VALUES ('ElonMusk', '$2b$10$m5KlgVK7z.OC3piUGgk2YOT1ke0bepiwTrydFbHy8ltXslu6pl1NS');
INSERT INTO User_info (user_id, name, created) VALUES (4, 'Elon Musk', NOW());

INSERT INTO User_friend (user_id, friend_id) VALUES (1, 2);
INSERT INTO User_friend (user_id, friend_id) VALUES (2, 1);
INSERT INTO User_friend (user_id, friend_id) VALUES (2, 3);

INSERT INTO Movie (title, runtime, genre, release_year, director, poster_path) VALUES ('Star Wars: Episode IV - A New Hope', 121, 'Action', 1977, 'Irvin Kershner', 'sw-ep4');
INSERT INTO Movie (title, runtime, genre, release_year, director, poster_path) VALUES ('Blade Runner 2049', 164, 'Action', 2017, 'Ridley Scott', 'br-2049');

INSERT INTO Seen (user_id, movie_id, date) VALUES (1, 1, NOW());
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





