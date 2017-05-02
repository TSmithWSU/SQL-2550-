use PurpleBox

db.createCollection("Movie")
db.createCollection("MovieItem")
db.createCollection("Users")
db.createCollection("Rentals")


db.Movie.save(
{
    "_id" : 1000,
    "MovieID" : "SWFA",
    "Title" : "Star Wars The Force Awakens",
    "Keywords" : "space",
    "Genre" : "Action",
    "Actors" : [ { "Actor Name": "Harrison Ford" }, { "Actor Name": "Mark Hamill" }, { "Actor Name": "Carrie Fisher" } ],
    "Director" : "J.J. Abrams"
}
)

db.Movie.save(
{
    "_id" : 1001,
    "MovieID" : "ST09",
    "Title" : "Star Trek",
    "Keywords" : "future",
    "Genre" : "Sci-Fi",
    "Actors" : [ { "Actor Name": "Chris Pine" }, { "Actor Name": "Zachary Quinto" }, { "Actor Name": "Zoe Saldana" } ],
    "Director" : "J.J. Abrams"
}
)

db.Movie.save(
{
    "_id" : 1002,
    "MovieID" : "HAGI",
    "Title" : "Happy Gilmore",
    "Keywords" : "golf",
    "Genre" : "Comedy",
    "Actors" : [ { "Actor Name": "Adam Sandler" }, { "Actor Name": "Christopher McDonald" }, { "Actor Name": "Julie Bowen" } ],
    "Director" : "Dennis Dugan" 
}
)

db.MovieItem.save(
{
    "_id" : 1000,
    "MovieID" : "HAGI",
    "Title" : "Happy Gilmore",
    "MovieItemID" : "Happ001",
    "Format" : "BLU",
    "CopyNum" : 2,
    "RentalDate" : ISODate("2017-02-10T08:21:72.289Z"),
    "ReturnDate" : ISODate("2017-02-13T10:40:42.379Z"),
    "DueDate" : ISODate("2017-02-13T11:40:22.389Z")
    
}
)

db.MovieItem.save(
{
    "_id" : 1001,
    "MovieID" : "SWFA",
    "Title" : "Star Wars The Force Awakens",
    "MovieItemID" : "SWFA001",
    "Format" : "BLU",
    "CopyNum" : 3,
    "RentalDate" : ISODate("2017-03-09T08:21:72.289Z"),
    "ReturnDate" : ISODate("2017-03-13T11:40:42.379Z"),
    "DueDate" : ISODate("2017-03-12T11:40:22.389Z")
    
}
)

db.MovieItem.save(
{
    "_id" : 1002,
    "MovieID" : "ST09",
    "Title" : "Star Trek",
    "MovieItemID" : "STTR001",
    "Format" : "DVD",
    "CopyNum" : 17,
    "RentalDate" : ISODate("2017-03-09T09:21:72.289Z"),
    "ReturnDate" : ISODate("2017-03-12T12:40:42.379Z"),
    "DueDate" : ISODate("2017-03-12T11:40:22.589Z")
    
}
)

db.Users.save(
{
    "_id" : 1000,
    "UserID" : "SP9001",
    "First Name" : "Jon",
    "Last Name" : "Bon Jovi",
    "UserType" : "Admin",
    "Password" : "LivinonaPrayer",
    "Security Questions" : 
    [ { "Question 1" : "What Bruce Willis Movie?" }, { "Question 2" : "What is your real last name?" } ], 
     "Security Question Answers" : 
    [ { "Answer 1" : "Armageddon " }, { "Answer 2" : "Bongiovi" } ],
    "Phone Numbers" :
    [{"Phone Number" : "665-254-6658"},
    {"Phone Number" : "669-574-3691"}],
    "CustType" : "R",
    "CustStatus" : "Good",
    "Overdue Fees" : 0,
    "Quota" : 2,
}
)

db.Users.save(
{
    "_id" : 1001,
    "UserID" : "SANT662",
    "First Name" : "Kent",
    "Last Name" : "Brockman",
    "UserType" : "Cust",
    "Password" : "Simpsons2",
    "Security Questions" : 
    [ { "Question 1" : "What is your Occupation?" }, { "Question 2" : "What is your wife's name?" } ], 
     "Security Question Answers" : 
    [ { "Answer 1" : "News anchor" }, { "Answer 2" : "Stephanie" } ],
    "Phone Numbers" :
    [{"Phone Number" : "998-874-6621"},
    {"Phone Number" : "998-227-3699"}],
    "CustType" : "R",
    "CustStatus" : "Good",
    "Overdue Fees" : 0,
    "Quota" : 2,
}
)

db.Rentals.save(
{
    "_id" : 1000,
    "UserID" : "SP9001",
    "MovieID" : "ST09",
    "Title" : "Star Trek",
    "MovieItemID" : "STTR001",
    "Format" : "DVD",
    "CopyNum" : 17,
    "RentalDate" : ISODate("2017-03-09T09:21:72.289Z"),
    "ReturnDate" : null,
    "DueDate" : ISODate("2017-03-12T11:40:22.589Z")
    
}
)

db.Rentals.save(
{
    "_id" : 1001,
    "MovieID" : "SWFA",
    "UserID" : "SP9001",
    "Title" : "Star Wars The Force Awakens",
    "MovieItemID" : "SWFA001",
    "Format" : "BLU",
    "CopyNum" : 3,
    "RentalDate" : ISODate("2017-03-09T08:21:72.289Z"),
    "ReturnDate" : null,
    "DueDate" : ISODate("2017-03-12T11:40:22.389Z")
    
}
)

db.getCollection('Rentals').find({})

db.getCollection('MovieItem').find({_id: {$gt:100}}, {_id:0, MovieID:1, Title:1, CopyNum:1,Format:1})

db.getCollection('Rentals').find({_id: {$gt:100}}, 
{_id:0, MovieItemID:1, UserID:1, RentalDate:1, ReturnDate:1 })

db.Rentals.save(
{
    "_id" : 1001,
    "MovieID" : "SWFA",
    "UserID" : "SP9001",
    "Title" : "Star Wars The Force Awakens",
    "MovieItemID" : "SWFA001",
    "Format" : "BLU",
    "CopyNum" : 3,
    "RentalDate" : ISODate("2017-03-09T08:21:72.289Z"),
    "ReturnDate" : ISODate("2017-03-13T11:40:42.379Z"),
    "DueDate" : ISODate("2017-03-12T11:40:22.389Z")
    
}
)

db.getCollection('Rentals').find({_id: {$gt:100}}, 
{_id:0, MovieItemID:1, UserID:1, RentalDate:1, ReturnDate:1 })

db.getCollection('MovieItem').remove({ 'MovieID' : 'HAGI' });