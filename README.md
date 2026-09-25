# Sarah Kaye S. Rumbawa, IT Student
## INF233
## CTADMOBL Advance Mobile Programming

A Flutter Project that focuses on advance topics. Covering the web to mobile transactions

## Lab Activity Instance

## Laboratory list

[svg](https://github.com/col3guy/rumbawa_mobprogAY2627/tree/lab_act1#laboratory-list)

- **Lab 1 - Theme(Dark/Light Mode)**: setState comes built right into Flutter and handles state that belongs to just one widget when it's called, only that widget rebuilds, and once the widget is gone, so is the data, which makes it perfect for small, local things like a counter or a checkbox. Provider, by contrast, needs the separate provider package and keeps its state outside of any single widget, allowing that data to be accessed and shared across many different screens, with every listening widget automatically rebuilding whenever the data updates. Put simply, `setState` suits quick, one-off, widget-level data, whereas Provider is meant for information like theme settings or login state that the whole app needs to keep track of.

- **Lab 2**: The model, services, and screen work together to get and show the data from the API. The model keeps the format of the data, the service connects to the API and gets the needed information, and the screen displays the data to the user. The new design pattern separates each part of the app, which makes the code cleaner, easier to understand, and easier to fix or change.

- **Lab 3**: The **Cart Model** stores the cart information, while the **Cart Service** gets the data from the API. The **Cart Screen** displays the cart products and opens the same ProductDetailsScreen when a product is clicked. The updated design separates the model, service, and screen, making the code easier to understand and manage. The `getById` method uses the user's ID to find the correct cart. This makes sure that only the logged-in user's cart is displayed.

- **Lab 4**: The **User Model** stores the user's information, while the **User Service** saves and retrieves the data using SharedPreferences. The **Splash Screen** checks the saved authentication token to determine whether the user is already logged in. The **Login Screen** handles authentication and saves the user's information after a successful login. The **Home Screen** displays the user's profile data, while the **Cart Screen** uses the user's ID to display the correct cart. These enhancements separate the authentication, user data, and UI responsibilities, making the application easier to understand and manage while supporting persistent login and user-specific cart data.

- **Lab 5**: The workflow starts with **Sign In and Sign Up**, where DummyJSON handles user authentication through the UserService, while Firebase provides a real account-based authentication system. The main purpose of **UserService** is to handle authentication and user data separately from the UI, making the Flutter application more organized and easier to maintain. Firebase benefits the application by providing secure authentication, persistent login sessions, and a scalable backend for managing users.