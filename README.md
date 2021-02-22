# mini_poker_rails

- Open a terminal.
- Execute "bundle install" to install the gems.
- Execute: rails "db:migrate" to create the database.
- Execute: "curl --compressed -o- -L https://yarnpkg.com/install.sh | bash" to prepare to installation of webpacker.
- Execute "rails webpacker:install"

- After run the migrations, in addition to the tables it will be create the views vw_hands and vw_moves, that are very useful to see in an organizated way the hands and the moves.

- In the folder "documentation" there is a PNG image with the model of the database.

- After execute the "rails server" command in the console, you can access the application in the adress bellow:
- http://localhost:3000/

- To see all the tests created, execute in console "rspec -fd".