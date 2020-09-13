# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(username: "vvs", password: "sample")
drivers = Driver.create(
    [
        {drivername: 'DriverAA', rating: 4.3, rides_count: 10},
        {drivername: 'DriverBB', rating: -1, rides_count: 0},
        {drivername: 'DriverCC', rating: 4.83, rides_count: 15},
        {drivername: 'DriverDD', rating: 4.8, rides_count: 4},
        {drivername: 'DriverEE', rating: 4.5, rides_count: 2}
    ]
)