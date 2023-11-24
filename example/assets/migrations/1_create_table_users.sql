CREATE TABLE if not exists 
    users (
        `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        `name` TEXT,
        `user_name` TEXT, 
        `password` TEXT,
        `status` INTEGER
    );
    