# Pawpal Project - Pet Management
A platform for user to appyly services for their beloved pet. This application include features for adoption and donation so Pet Lover Communities can help each other <3

## Features of Project
1. User Authentication
   - Register user
   - Login User
   - Remember me for auto login
2. User Profile
   - Show user's registered data
   - User can edit the profile data
   - include profile picture
   - include wallet poin
4. Pet Details Submission
   -Submit up to 3 images
   -Fill pet details (name, type, health, description)
   -Category of help (adoption, donation, help, etc)
6. View Pet
   -View other pets
   -Help pet of your choice

## API Table

| No | Endpoint               | Method | Purpose                |
|:--:|:-----------------------|:------:|:-----------------------|
|  1 | `/login.php`           | POST   | User authentication    |
|  2 | `/register_user.php`   | POST   | Create new user        |
|  3 | `/get_my_pets.php`     | GET    | Browse pets            |
|  4 | `/submit_pets.php`     | POST   | Submit new pet         |
|  5 | `/get_my_donation.php` | GET    | Load donation requests |
|  6 | `/submit_donation.php` | POST   | User Donate            |
|  7 | `/get_user_details.php`| GET    | Get user info          |
|  8 | `/submit_adopt.php`    | POST   | Request adoption to owner|
|  9 | `/submit_profile.php`  | POST   | Submit profile update  |



