# Ten mins Five ingredients

<img src="assets/images/homepageview.png" alt="Home Page" width="300" />

Ten mins Five ingredients provides users with ultra-fast recipes that can be prepared in approximately ten minutes, utilizing a maximum of five ingredients.

## How it Works

This application offers users quick and easy recipes that can be prepared in just about ten minutes, using a maximum of five ingredients. Users can either upload their own recipes or make use of the fridge image detection feature to get three suitable recipes based on the ingredients they have.
The application is developed using Flutter and makes use of the OpenAI API, as well as Firebase Authentication and Realtime Database.


## Getting Started

To run Ten mins Five ingredients locally on your machine, follow these steps:

1. Clone this repository.
2. Navigate to the project directory.
3. Create a .env file in the root of the project with the example content:
 ```sh
    OPENAI_API_KEY= PUT YOUR KEY HERE
```
4.Currently the Database is connected to our own Firebase database, if you'd like to use your database, remember to replace the `firebase_options.dart` file and update the path.

## License

Ten mins Five ingredients is released under the [MIT License](/path/to/license).
