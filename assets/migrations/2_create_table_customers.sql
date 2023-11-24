CREATE TABLE if not exists 
    customers (
        `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY, 
        `name` varchar(255),
        `phone` varchar(255),
        `gender` varchar(255),
        `address` varchar(255),
        `type` varchar(15),
        `active` tinyint(1)
    );