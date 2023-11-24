CREATE TABLE if not exists 
    users (
        `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY, 
        `name` varchar(255),
        `phone` varchar(255),
        `email` varchar(255),
        `user_name` varchar(255), 
        `password` varchar(255),
        `active` tinyint(1)
    );
    