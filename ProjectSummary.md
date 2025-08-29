# Introduction

The PG_Application is a simple app I made using Flutter. It helps people find good places to stay as paying guests. In India, many students and workers need safe and cheap rooms when they move to new cities like Surat. This app makes it easy to search for these places without much trouble.

The main goal of this project is to create an app that is easy to use. Users can look for paying guest rooms, see details like price, location, and photos, and even add reviews or favourites. I wanted to help people find homes quickly, so they can focus on their studies or jobs.

In this project, I learned how to build screens, add features like login and search, and make the app look nice. My aim was to make something useful for real life. For example, if someone is new in a city, they can open the app, type their needs, and find options fast. I also added things like reviews and favourite your pg.
Overall, this app shows my first try at solving a common problem with technology. I hope it helps users and teaches me more about coding. The rest of this document tells about what the app does and how I built it.

# Project Overview

The PG_Application is a simple and user-friendly app that helps people find paying guest (PG) rooms near their city or anywhere in the city. It makes searching for safe and affordable places easy, especially for students or workers moving to new areas like Surat in Gujarat. The app has a clean design so anyone can use it without confusion. For example, if you're new to a city and need a place to stay, you can open the app, see options nearby, and pick one that fits your needs. This saves time and makes finding a home less stressful.

I used Flutter as the main framework to build the app, which works on both Android and iOS with the same code. This was great for me as a beginner because it's fast and has many tools. For the backend, I chose Firebase for things like user data, authentication, and real-time updates. it's secure and easy to connect. I also used Supabase for storing images since Firebase isn't the best for that, and I linked them together to handle everything smoothly. These choices made the app reliable without too much complexity.

To add more functions, I included many helpful packages that saved time during coding. For forms and inputs, I used flutter_form_builder and form_builder_validators. Things like carousel_slider helped show PG room photos in a nice sliding way, and geolocator finds the user's location for nearby searches. Check the full list below for all packages. I picked them after researching what works best for Flutter apps.

| Feature             | Description                                                                                                              |
|---------------------|--------------------------------------------------------------------------------------------------------------------------|
| Sign In and Sign Up | Real-time login and signup using Firebase authentication—secure and reliable. Users get quick access without long waits. |
| Home Screen         | Shows PG rooms near your location in a clean slider; pick a city to see more options tailored to you.                    |
| Search Feature      | Search by PG name, city, or add filters like price or amenities for what you need exactly.                               |
| Favorites Feature   | Save PG rooms you like and view them later in a special screen—perfect for comparing choices.                            |
| Reviews Feature     | Leave feedback on PG rooms to help others decide, building a community of trust.                                         |
| Profile Edit        | Change your details or profile picture anytime, keeping your info up to date.                                            |
| Admin Screen        | Admins can add, update, or delete PG rooms easily, keeping the app fresh with new listings.                              |



### Packages Used
-	flutter_form_builder: ^10.1.0
-	form_builder_validators: ^11.2.0
-	stylish_bottom_bar: ^1.1.1
-	carousel_slider: ^5.1.1
-	lazy_load_scrollview: ^1.3.0
-	image_picker: ^1.2.0
-	file_picker: ^10.3.1
-	cloud_firestore: ^6.0.0
-	firebase_core: ^4.0.0
-	firebase_auth: ^6.0.1
-	uuid: ^4.5.1
-	geolocator: ^14.0.2
-	geocoding: ^4.0.0
-	intl: ^0.20.2
-	supabase_flutter: ^2.9.1
-	cached_network_image: ^3.4.1
-	http: ^1.5.0
-	flutter_typeahead: ^5.2.0
-	dropdown_search: ^6.0.2
-	url_launcher: ^6.3.2
-	rxdart: ^0.28.0

Overall, this app combines simple tech with useful features to solve a real problem in finding PG rooms. It was my way to practice building something practical from start to finish.


# What I Did And Learned

## Day 1-3 : Research and Design Phase
- In the first three days, I did research on features for the PG Application. I looked at what the app needs, like user login and search tools. I decided the total components of the app, such as screens and buttons. Then, I designed rough images on a notebook to plan the layout. After that, I made the actual designs for every page using design tools.
- I learned about planning and design. It helped me see how the app will work and connect all parts. This phase was important for starting the project well.

## Day 4-10 : Building Actual Frontend Design
- From day 4 to 10, I focused on creating all the main screens for my PG Application in Flutter. I built the home page, listing page, view details page, profile page, login page, and signup page. I also read the guideline PDF, which gave me good ideas, so I decided to add a favorite page and a reviews system to make the app more useful for users.
- I learned about some useful packages like flutter_form_builder for making forms easier, validator package for checking inputs, carousel slider for showing images nicely, and a few more. These packages saved time and made coding simpler.
- [[Watch Short Video Showcasing Frontend]](https://youtu.be/he13FwBhIZE)

## Day 11-15 : Backend Phase
- From day 11 to 15, I worked on the backend of my PG_Application. The frontend was already ready, so I started the backend part. I did not do too much, just added Firebase and set up basic authentication for the app. This included making login and signup pages work with real user checks. I also added a splash screen to show when the app starts.
- I learned about connecting Firebase to Flutter and how authentication works. It was new to me, but now I know how to make users sign in safely and store their info. This made the app more real and secure.

## Day 16-25 : Implementing the Backend Features
- From day 16 to 25, I did the main backend work for my PG_Application. First, I worked on the admin screen to add, update, and delete PG rooms. It took some time, but I got it done. I learned that I can't store images easily in Firebase, so I used Supabase for images and connected it with Firebase to make them work together.
- Next, I displayed those records on the home screen and search screen. This part took more time than the admin screen. Then, I added the favourites feature, if a user likes a PG room, it shows up in the favourites screen. After that, I implemented the search feature with filters, which was hard and took a long time. Finally, I added reviews for the PG rooms so users can share their thoughts.
- I learned a lot about Firebase and Supabase, plus some packages that made coding easier. This helped me understand how to handle data and make the app more interactive.
- [Download My Working Application](app-release.apk)

# Challenges and Reflections

## 1st Challenge – Implementing animations in Flutter
- First challenge in my PG Application project was getting started with animations in Flutter. I didn't know much about them at first, which made it tricky to make the app feel smooth and fun. So, I jumped in by learning the basics through some easy YouTube tutorials, found a few helpful templates online, and just played around with them until things clicked. In the end, I created simple route animations for navigating between the login and register pages, which was a cool win and taught me how animations can make the user experience way better.

## 2nd Challenge – How to Write Document For My Project?
- Another challenge I faced in my Flutter project was figuring out how to write proper documentation. I had no idea where to start or what it should look like, which felt overwhelming at first. For reflection, I searched the internet for examples and templates of computer science project docs, checked out some AI tools and other resources, and that's how I learned about good layouts. In the end, I decided on a clear structure for my document, and hey, you're seeing it right now as you read this! It was a great lesson in organizing my thoughts and making everything easier to follow.

## 3rd Challenge – Backend Implantation
- Backend implementation was tough because I was totally new to Firebase and Supabase—I had no idea how they worked before this. It was my first big project in Flutter using both together, so everything felt overwhelming at the start. For reflection, I had to learn a bunch from YouTube videos and searching questions on Stack Overflow, which helped me fix tons of errors step by step. Slowly, I solved all the problems, and even though it was really hard the first time, that's how I got the backend up and running. It taught me to be patient and keep trying when things go wrong.



# Conclusion

In wrapping up my PG_Application project, I can say it was a big success for my first real app in Flutter. I started with simple research and designs on paper, then built all the screens like home, search, favorites, reviews, profile, and admin panels. Adding backend with Firebase for authentication and data, plus Supabase for images, made everything work together smoothly. Features like real-time sign-up, location-based PG room searches, filtering, favoriting, and leaving reviews turned it into a helpful tool for people needing affordable stays in cities like Surat.

Through the days, I learned so much from animations for smooth page changes, to using packages like flutter_form_builder, carousel_slider, and geolocator that saved time and made coding easier. Challenges popped up, like figuring out animations when I knew little about them, writing this documentation from scratch by looking at examples, and tackling backend errors with YouTube and Stack Overflow help. But solving them step by step built my confidence and showed me how to be patient in coding.

Overall, this project achieved my goal of creating a user-friendly app that solves a real problem: finding PG rooms quickly and safely. It taught me about planning, tech integration, and turning ideas into something real. If I do it again, I'd add more features to the application. I'm proud of what I made, it's not just an app, but a step forward in my learning as a beginner developer. This experience motivates me to try bigger projects next!

